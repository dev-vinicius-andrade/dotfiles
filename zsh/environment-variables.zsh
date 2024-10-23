#!/bin/zsh
get_windows_drive() {
  if [[ -z "$IS_WSL" ]]; then
    echo "The IS_WSL environment variable is not defined."
    return
  fi
  if [[ "$IS_WSL" != "true" ]]; then
    echo "This function is intended to be run inside WSL only."
    return
  fi
  # Determine the Windows installation drive
  local windows_drive=""
  for drive in /mnt/*; do
    if [[ -x "$drive/Windows/System32/cmd.exe" ]]; then
      windows_drive="$drive"
      break
    fi
  done
  # Check if the Windows installation drive was found
  if [[ -z "$windows_drive" ]]; then
    echo "Could not determine the Windows installation drive."
    return
  fi
  echo "$windows_drive"
}
add_windows_environment_variable_path_to_wsl() {
  # Get the value of the Windows environment variable using PowerShell
  local windows_path_var="$1"
  if [[ -z "$windows_path_var" ]]; then
    echo "The Windows environment variable name is required."
    return
  fi
  local windows_paths=$("$WINDOWS_DRIVE/Windows/System32/cmd.exe" "/C" "echo %PATH%" 2>/dev/null | tr -d '\r' | sed 's/\\/\//g')

  if [[ -z "$windows_paths" ]]; then
    echo "The environment variable '$windows_path_var' does not exist."
    return
  fi
  local unix_paths=""

  for windows_path in ${(s/;/)windows_paths}; do
    trimmed_path="${windows_path#"${windows_path%%[![:space:]]*}"}" # Remove leading spaces
    trimmed_path="${trimmed_path%"${trimmed_path##*[![:space:]]}"}" # Remove trailing spaces
    wsl_path=$(wslpath "$trimmed_path")
    unix_paths+="$wsl_path:"
  done
  unix_paths=${unix_paths%:}
  export PATH="$PATH:$unix_paths"
}

if grep -qi 'microsoft\|wsl' /proc/version; then
  export IS_WSL=true
  export WINDOWS_DRIVE="$(get_windows_drive)"

  add_windows_environment_variable_path_to_wsl "PATH"
  echo "WINDOWS_DRIVE=$WINDOWS_DRIVE"
else

  export HOST_HOME=$HOME
  export IS_WSL=false
fi

export SECRETS_DIR="$DOT_FILES_DIR/.secrets"
export SECRET_ENV_FILE="$SECRETS_DIR/.env.secret.zsh"
export GCP_DIR="$HOME/.gcp"
export PATH="/usr/local/opt/libxml2/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/libxml2/lib"
export CPPFLAGS="-I/usr/local/opt/libxml2/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"
export repos="$HOME/Development/repos/"
export PATH="$PATH:$HOME/.dotnet/tools:$HOME/.local/bin"
export APPDATA="$HOME"
export PYTHON=/usr/bin/python3
if [ -d "$HOME/.dotnet/tools" ]; then
  export PATH="$HOME/.dotnet/tools:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi
if [[ -f "$HOME/.kube/config" && -z $KUBECONFIG ]]; then
  export KUBECONFIG="$HOME/.kube/config"
fi
