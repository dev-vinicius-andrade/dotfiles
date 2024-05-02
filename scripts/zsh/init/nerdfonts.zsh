#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
download_and_install_fonts()
{
    source "$DOTFILES_DIR/scripts/zsh/spinning_progress_bar.zsh"
    source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
    install_package "unzip"
    mkdir -p ~/.fonts
    echo "[-] Downloading fonts: [-]"
    declare -a fonts_zips_uris=(
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Terminus.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Ubuntu.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Agave.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/NerdFontsSymbolsOnly.zip"
    )
    local total_fonts=${#fonts_zips_uris[@]}
    local current_file=1
    for fonts_zip_uri in "${fonts_zips_uris[@]}"
    do
        local message="[-] Downloading font: $fonts_zip_uri"
        report_progress "$current_file" "$total_fonts" "$message"
        wget -q -O tmpFont.zip "${fonts_zip_uri}" || { echo "Failed to download $fonts_zip_uri"; continue; }
        echo "Attempting to unzip tmpFont.zip..."
        unzip -o -q tmpFont.zip -d ~/.fonts || { echo "Failed to unzip tmpFont.zip"; continue; }
        echo "Successfully unzipped tmpFont.zip"
        rm tmpFont.zip
        current_file=$((current_file + 1))
    done
    end_progress
    if [ -f "$DOTFILES_DIR/tmpFont.zip" ]; then
        rm "$DOTFILES_DIR/tmpFont.zip"
    fi

    local os=$(uname -s)
    if [ "$os" = "Darwin" ]; then
        cp -r ~/.fonts/* ~/Library/Fonts
        echo "[-] Fonts downloaded and installed to ~/Library/Fonts"
    elif [ "$os" = "Linux" ]; then
        sudo mkdir -p /usr/local/share/fonts
        sudo cp -r ~/.fonts/* /usr/local/share/fonts
        echo "[-] Fonts downloaded and installed to /usr/local/share/fonts"
    else
        echo "Unsupported OS: $os"
        exit 1
    fi
}
install_nerd_fonts()
{

    local skip="${1:---no-skip}"
    print_section_start "Nerd Fonts"
    if ! [ -x "$(command -v nerd_fonts)" ]; then
        if ! [ -d ~/.fonts ]; then
            download_and_install_fonts
        else
            echo "[-] Fonts already downloaded: [-]"
            if [ "$skip" = "--skip" ]; then
                echo "[-] Skipping fonts download: [-]"
                return
            fi
            echo "[-] Do you want to download them again? [y/n]: [n]"
            read -r answer
            if [ "$answer" = "y" ]; then
                download_and_install_fonts
            else
              echo "[-] Skipping fonts download: [-]"
            fi
        fi
    fi
    print_section_end
}
if [[ "$1" = "--skip" ]]; then
    install_nerd_fonts "--skip"
else
    install_nerd_fonts
fi





