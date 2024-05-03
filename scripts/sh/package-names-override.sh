#! /bin/bash

get_distribution_package_name_override() {
    local package_name="$1"
    local distro="$(
        . /etc/os-release
        echo $ID
    )"

    local config_file="$DOTFILES_DIR/package-names-override.yaml"

    # Default to the package name itself if no override is found
    local override_name="$package_name"

    # Ensure the configuration file exists
    if [[ ! -f "$config_file" ]]; then
        echo "Config file not found: $config_file"
        return 1
    fi

    # Read the configuration file and search for an override
    local line=$(grep "^$package_name-$distro:" "$config_file")
    if [[ -n "$line" ]]; then
        override_name=$(echo "$line" | awk -F ':' '{print $2}' | xargs)
    fi
    echo "$override_name"
}

get_distribution_package_names_override() {
    local package_names=("$@")

    local packages_names_override=""
    for package_name in "${package_names[@]}"; do
        package_names_override+=("$(get_distribution_package_name_override "$package_name")")
    done
    echo "${package_names_override[*]}"
}
