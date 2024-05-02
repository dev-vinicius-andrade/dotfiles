#! /bin/zsh
# export DOTFILES_DIR="$(cd "$(dirname "$0")" &>/dev/null && pwd)"
local scripts_dir="$DOTFILES_DIR/scripts/zsh"
local init_scripts_dir="$scripts_dir/init"
source "$scripts_dir/init_scripts_runner.zsh"
source "$scripts_dir/utils.zsh"
add_scritps_permissions() {
  local scripts_dir="$DOTFILES_DIR/scripts/zsh"
  source "$scripts_dir/spinning_progress_bar.zsh"
  local init_scripts_dir="$scripts_dir/init"
  local total_files=$(ls -l "$init_scripts_dir"/**/*(.) | wc -l)
  local current_file=1
  print_line "\nAdding permissions to scripts...\n"
  for file in "$init_scripts_dir"/**/*(.); do
    local message="Adding permissions to $file"
    if [[ -f "$file" ]]; then
      report_progress "$current_file" "$total_files" "$message"
      chmod u+r+x "$file"
    fi
    current_file=$((current_file + 1))
    sleep 0.1
  done
  end_progress
}
setup() {
  print_line "Starting setup ..."
  add_scritps_permissions
  add_script_to_priorities "app" 1
  add_script_to_priorities "node" 2
  # add_script_to_priorities "node" 2

  run "$init_scripts_dir" "$@"
}

setup "$@"
