##! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"

is_installed() {
  local package_name="$1"
  local os=$(uname -s)
  if command_exists "$package_name"; then
    return 0
  fi

  if [ "$os" = "Darwin" ]; then
    brew list "$package_name" >/dev/null 2>&1
  elif [ "$os" = "Linux" ]; then
    if [ -f /etc/debian_version ]; then
      dpkg -l "$package_name" >/dev/null 2>&1
    elif [ -f /etc/alpine-release ]; then
      apk info "$package_name" >/dev/null 2>&1
    elif [ -f /etc/arch-release ]; then
      pacman -Q "$package_name" >/dev/null 2>&1
    else
      echo "Unsupported Linux distribution"
      exit 1
    fi
  else
    echo "Unsupported OS: $os"
    exit 1
  fi

  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
    return 0 # Package is installed
  else
    return 1 # Package is not installed
  fi
}
install_package_using_brew() {
  local package_name="$1"
  local os=$(uname -s)
  local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "true")
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  if [[ "$os" == "Darwin" || "$use_homebrew_flag" == "--use-homebrew" ]]; then
    print_line "Installing $package_name using brew"
    sudo brew install "$package_name" "$@"
  else
    echo "Unsupported OS: $os"
    exit 1
  fi
}
install_package_using_apt() {
  local package_name="$1"
  local os=$(uname -s)
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  if [ "$os" = "Linux" ]; then
    if [ -f /etc/debian_version ]; then
      sudo apt-get -y install "$package_name" "$@"
    else
      echo "Unsupported Linux distribution"
      exit 1
    fi
  else
    echo "Unsupported OS: $os"
    exit 1
  fi
}
install_package_using_apk() {
  local package_name="$1"
  local os=$(uname -s)
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  if [ "$os" = "Linux" ]; then
    if [ -f /etc/alpine-release ]; then
      sudo apk add "$package_name" "$@"
    else
      echo "Unsupported Linux distribution"
      exit 1
    fi
  else
    echo "Unsupported OS: $os"
    exit 1
  fi
}
install_package_using_pacman() {
  local package_name="$1"
  local os=$(uname -s)
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  if [ "$os" = "Linux" ]; then
    if [ -f /etc/arch-release ]; then
      sudo pacman -S "$package_name" --noconfirm --needed "$@"
    else
      echo "Unsupported Linux distribution"
      exit 1
    fi
  else
    echo "Unsupported OS: $os"
    exit 1
  fi
}
install_package_using_cargo() {
  local package_name="$1"
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  if ! command_exists "cargo"; then
    echo "Cargo is not installed or not in PATH"
    exit 1
  fi
  cargo install "$package_name" "$@"

}
install_package_using_snap() {
  local package_name="$1"
  local os=$(uname -s)
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  if [ "$os" = "Linux" ]; then
    if [ -f /etc/debian_version ]; then
      sudo snap install "$package_name" "$@"
    else
      echo "Unsupported Linux distribution"
      exit 1
    fi
  else
    echo "Unsupported OS: $os"
    exit 1
  fi
}
install_package_using_npm() {
  local package_name="$1"
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  npm install -g "$package_name" "$@"
}
install_package_using_dotnet() {
  local package_name="$1"
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  dotnet tool install -g "$package_name" "$@"
}
install_package_using_pip() {
  local package_name="$1"
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  pip install "$package_name" "$@"
}
install_package_using_go_get() {
  local package_name="$1"
  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  go get -u "$package_name" "$@"
}
install_package() {
  local package_name="$1"
  local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "true")
  local os=$(uname -s)

  if is_installed "$package_name" "$use_home_brew_flag"; then
    echo "$package_name is already installed"
    return
  fi
  # if use_homebrew_flag is set and equals to --use-homebrew
  if [ "$use_homebrew_flag" = "--use-homebrew" ]; then
    install_package_using_brew "$package_name" "$@" "--use-homebrew"
    return
  fi

  if [ "$os" = "Darwin" ]; then
    brew install --cask "$package_name" "$@"
  elif [ "$os" = "Linux" ]; then
    if [ -f /etc/debian_version ]; then
      if install_package_using_apt "$package_name" "$@"; then
        return
      elif install_package_using_cargo "$package_name" "$@"; then
        return
      elif install_package_using_snap "$package_name" "$@"; then
        return
      fi
      echo "Unable to install $package_name"
      exit 1
    elif [ -f /etc/alpine-release ]; then
      sudo apk add "$package_name" "$@"
    elif [ -f /etc/arch-release ]; then
      print "Installing $package_name"
      sudo pacman -S "$package_name" --noconfirm --needed "$@"
    else
      echo "Unsupported Linux distribution"
      exit 1
    fi
  else
    echo "Unsupported OS: $os"
    exit 1
  fi
}
