if [ -f ". "$HOME/.cargo/env"" ]; then
fi
export TERM=xterm-256color
unset PROMPT_COMMAND
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
