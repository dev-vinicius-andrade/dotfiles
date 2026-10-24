if [ -f ". "$HOME/.cargo/env"" ]; then
fi
export TERM=xterm-256color
unset PROMPT_COMMAND
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export NETAVARK_FW=iptables
export PROXMOX_VE_ENDPOINT="https://proxmox-01.andrades.cloud:8006/"
export PROXMOX_VE_API_TOKEN="root@pam!claude-code=158b2000-ba2b-4eb1-adcb-8e9edee6184b"
export PFSENSE_URL="https://pfsense.andrades.cloud:8443/"
export PFSENSE_API_KEY="48aea851f66be93d279b40d95bc17a4f"
export TECHNITIUM_URL="https://dns.andrades.cloud"
export TECHNITIUM_TOKEN="7a866829e2a2bdba72126837d419f8a0fa09d635313e16b7dc4c1354923556a0"
export SOPS_AGE_KEY_FILE="$HOME/.ssh/keys.txt"
export EDITOR=nvim
export PATH="$HOME/.atuin/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
