#! /bin/zsh
if grep -qi 'microsoft\|wsl' /proc/version; then
  export IS_WSL=true
  export HOST_HOME=$(wslpath $(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null) | tr -d '\r')
else
  export IS_WSL=false
  export HOST_HOME=$HOME
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
