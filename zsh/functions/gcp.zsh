#! /bin/zsh
function switch_gcp_credentials() {
  local gcp_dir="$HOME/.gcp"
  local google_credentials_path="$GOOGLE_APPLICATION_CREDENTIALS"

  if [ ! -d "$gcp_dir" ]; then
    echo "GCP directory '$gcp_dir' does not exist."
    return 1  # Indicate an error with exit status 1
  fi

  local json_files=($(find "$gcp_dir" -type f -name "*.json"))
  local filtered_json_files=()

  if [ ${#json_files[@]} -eq 0 ]; then
    echo "No JSON files found in $gcp_dir."
    return 1  # Indicate an error with exit status 1
  fi

  # Iterate through json_files and add only those with different paths to filtered_json_files
  for json_file in "${json_files[@]}"; do
    if [ "$json_file" != "$google_credentials_path" ]; then
      filtered_json_files+=("$json_file")
    fi
  done

  # Append the "Quit" option to the filtered list
  filtered_json_files+=("Quit (you can also press 'q')")

  local selected_index=1

  # Disable terminal scrolling temporarily
  
  local last_input=""
  tput rmcup
  while true; do
    clear
    
    if [ -n "$google_credentials_path" ]; then
      echo "Your current selected credential is:"
      echo -e "\033[1;32m$google_credentials_path\033[0m"
      echo
      
    fi
    echo
    echo "$last_input"
    echo "Select a JSON file using arrow keys (UP/DOWN) and press Enter to set it as GOOGLE_APPLICATION_CREDENTIALS:"
  
    for ((i=1; i<=${#filtered_json_files[@]}; i++)); do
      local json_file="${filtered_json_files[$i]}"
      

      if [ $selected_index -eq $i ]; then
        echo -e "\033[1;32m >$i. $json_file\033[0m"
      else
        echo " $i. $json_file"
      fi
    done
while true; do
  # Read a single character from standard input without echoing it
  IFS= read -rsk1 input

  # Check if the input is an escape character (ASCII 27)
  if [[ "$input" == $'\e' ]]; then
    # Read two more characters for the escape sequence
    IFS= read -rsk2 sequence

    case "$sequence" in
      '[A')  # Up arrow key
        echo "Arrow Up key pressed."
        # Add your arrow up key logic here
        ;;
      '[B')  # Down arrow key
        echo "Arrow Down key pressed."
        # Add your arrow down key logic here
        ;;
      *)
        # Handle other escape sequences here if needed
        ;;
    esac
  else
    # Handle non-escape key presses here if needed
    echo "Key pressed: $input"
  fi
done













    # case "$input" in
    #   "q")
    #     break
    #     ;;
    #   "[A")  # Up arrow key
    #     ((selected_index--))
    #     [ $selected_index -lt 0 ] && selected_index=$(( ${#filtered_json_files[@]} - 1 ))
    #     ;;
    #   "[B")  # Down arrow key
    #     ((selected_index++))
    #     [ $selected_index -ge ${#filtered_json_files[@]} ] && selected_index=0
    #     ;;
    #   "")  # Enter key
    #     local selected_option="${filtered_json_files[$selected_index]}"
    #     if [ "$selected_option" = "Quit" ]; then
    #       echo "Quitting without changing GOOGLE_APPLICATION_CREDENTIALS."
    #       return 0  # Indicate success with exit status 0
    #     else
    #       echo "Selected: $selected_option"
    #       export GOOGLE_APPLICATION_CREDENTIALS="$selected_option"
    #       echo "GOOGLE_APPLICATION_CREDENTIALS updated."
    #       return 0  # Indicate success with exit status 0
    #     fi
    #     ;;
    # esac
  done

  # Re-enable terminal scrolling
  tput smcup
}