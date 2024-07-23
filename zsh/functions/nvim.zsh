#! /bin/zsh
generate_nvim_languages_to_install_json() {
    local json_file="$HOME/.config/nvim/languages-to-install.json"

    # Check if the file exists
    if [ -f "$json_file" ]; then
        echo "File $json_file already exists. Skipping creation."
    else
        # Create the directory if it doesn't exist
        mkdir -p "$(dirname "$json_file")"

        # Write an indented empty JSON object to the file
        echo "{" >"$json_file"
        echo "}" >>"$json_file"
        echo "File $json_file created with an indented empty JSON object."
    fi
}
