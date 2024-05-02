##! /bin/zsh
is_installed() {
  local package_name="$1"
  local os=$(uname -s)

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

install_package() {
  local package_name="$1"
  local os=$(uname -s)

  if is_installed "$package_name"; then
    echo "$package_name is already installed"
    return
  fi
  if [ "$os" = "Darwin" ]; then
    brew install --cask "$package_name" "$@"
  elif [ "$os" = "Linux" ]; then
    if [ -f /etc/debian_version ]; then
      sudo apt-get install -y "$package_name" "$@"
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
