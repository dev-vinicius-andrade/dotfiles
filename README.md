# dotfiles

Repository to version my current dotfiles and scripts to set up my development environment.

Currently, I'm using the same dotfiles to work either on MacOS and Windows WSL.

The main goal of this repository is to automate the setup of my development environment, installing all dependencies and setting up the configuration files.

## Table of contents

Checkout the table of contents to navigate through the repository documentation.

- [Clone and give script permission](#clone-and-give-script-permission)
  - [Clone and give script permission Macos](#clone-and-give-script-permission-macos)
  - [Clone and give script permission Linux](#clone-and-give-script-permission-linux)
  - [Clone and give script permission Windows WSL](#clone-and-give-script-permission-windows-wsl)

  - [Running](#running)
    - [Running on MacOS](#running-on-macos)
    - [Running on Linux](#running-on-linux)
    - [Running on Windows WSL](#running-on-windows-wsl)
    - [Init Script Options](#init-script-options)

### Clone and give script permission

Take a look at the following sections to clone the repository and give the script permission to run according to your operating system.

- [Clone and give script permission Macos](#clone-and-give-script-permission-macos)
- [Clone and give script permission Linux](#clone-and-give-script-permission-linux)
- [Clone and give script permission Windows WSL](#clone-and-give-script-permission-windows-wsl)

#### Clone and give script permission Macos

If you are using **MacOS**, you can clone the repository and give the script permission to run.

```shell
cd ~/ && git clone git@github.com:dev-vinicius-andrade/dotfiles.git && \
chmod +x ~/dotfiles/init.zsh
```

#### Clone and give script permission Linux

I'll separate this in two sections:

- [Clone and give script permission Linux](#clone-and-give-script-permission-linux)
- [Clone and give script permission Windows WSL](#clone-and-give-script-permission-windows-wsl)

##### Clone and give script permission Linux Os

If you are using a **Linux Os**, you can clone the repository and give the script permission to run.

```shell
cd ~/ && git clone git@github.com:dev-vinicius-andrade/dotfiles.git && \
chmod +x ~/dotfiles/init.zsh
```

##### Clone and give script permission Windows Wsl

> You can checkout more about installing **WSL** in [Microsoft Docs](https://learn.microsoft.com/en-us/windows/wsl/install) case you don't have it.

If you are using Windows WSL, like I'm, that could be a *little bit tricky*.

As my linux tests were made on WSL, I figured out that the best way to clone the repository was to clone it directly on windows home directory.

- [Clone the repository on Windows](#clone-the-repository-on-windows)
- [Give script permission on WSL](#give-script-permission-on-wsl)

###### Clone the repository on Windows

So, let's use power shell to clone the re and navigate to your home directory and clone the repository.

```powershell
cd ~ && git clone git@github.com:dev-vinicius-andrade/dotfiles.git 
```

###### Give script permission on WSL

As I wanted to use the same dotfiles in different systems, with different usernames, the best way i found to work with was:

- Connect to the WSL Distribution terminal [Microsoft Docs](https://learn.microsoft.com/en-us/windows/wsl/install)
- Create a symbolic link to the dotfiles folder in the WSL home directory

> Notes: If you cloned the repository in another location rather than the user home directory, you should change the path in the commands below.

```shell
ln -sn "$(wslpath $(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null) | tr -d '\r')/dotfiles" ~/dotfiles
```

- Give the script permission to run

```shell
chmod +x ~/dotfiles/init.sh
```

### Running

After cloning the repository and giving the script permission to run, you can run the script to install all dependencies and set up the environment.

> As some tasks need sudo permission, you may need to enter your password during the script execution.

- [Running on MacOS](#running-on-macos)
- [Running on Linux](#running-on-linux)
- [Running on Windows WSL](#running-on-windows-wsl)

#### Running on MacOS

After [cloning the repository and giving the script permission](#clone-and-give-script-permission) to run, you can run the script to install all/or a specif set of dependencies and set up the environment.
> Notes: The script location depends where you cloned the repository.
> As some tasks need sudo permission, you may need to enter your password during the script execution.

```shell
~/dotfiles/init.sh #options
```

Checkout the [Init Script Options](#init-script-options) section to see the available options.

#### Running on Linux

After [cloning the repository and giving the script permission](#clone-and-give-script-permission) to run, you can run the script to install all/or a specif set of dependencies and set up the environment.
> Notes: The script location depends where you cloned the repository.
> As some tasks need sudo permission, you may need to enter your password during the script execution.

```shell
~/dotfiles/init.sh #options
```

Checkout the [Init Script Options](#init-script-options) section to see the available options.

#### Running on Windows WSL

After [cloning the repository and giving the script permission](#clone-and-give-script-permission-windows-wsl) to run, you can run the script to install all/or a specif set of dependencies and set up the environment.

- Connect to the WSL Distribution terminal [Microsoft Docs](https://learn.microsoft.com/en-us/windows/wsl/install)
- You can follow the same instructions as the [Running on Linux](#running-on-linux) section.

## Examples of running the script

> Notes: The script location depends where you cloned the repository.
> As some tasks need sudo permission, you may need to enter your password during the script execution.

### Running without options

```shell
# The script will run all the tasks and asks for your inputs to continue;
~/dotfiles/init.sh
```

### Auto accept package licenses

```shell
# If you want to auto accept all package licenses, you can pass the -y|--yes|-Y flag
~/dotfiles/init.sh -y #options
```

Checkout the [Init Script Options](#init-script-options) section to see the available options.

### Skip already runned tasks

Or you can run it passing some [Init Script Options](#init-script-options) section to see the available options.

```shell
## The script will run all the tasks that are not already runned.
## The -y|--yes|-Y flag will auto accept package licenses
~/dotfiles/init.sh --skip #-y|--yes|-Y to auto accept package licenses
```

### Installing only some dependencies

You can also run the script to install only some dependencies.
In the example below, the script will run only the wezterm init script.

```shell
# The script will run only the wezterm init script.
~/dotfiles/init.sh --wezterm
```

### Skipping specific tasks

You can also skip some specific tasks.
In the example below, the script will skip the wezterm init script.
So, it will run all the tasks except the wezterm init script.

```shell
# The script will skip the wezterm init script.
~/dotfiles/init.sh --skip-wezterm
```

### A complete example

Let's assume you've run the script before with **--skip-wezterm** and now you want to install it.

```shell
# The script will run only the wezterm init script.
~/dotfiles/init.sh --skip_package_installation --skip_update --wezterm
# This will skip the package manager installation and updates, auto accept all package licenses and run only the wezterm init script.
```

### Help

As the code can be updated, make it's more reliable to check the available options directly in the script using the --help flag.
> Notes: The script location depends where you cloned the repository.
> As some tasks need sudo permission, you may need to enter your password during the script execution.

```shell
~/dotfiles/init.sh --help
```

## Init Script Options

The script has some options that you can use to install only run some specific tasks.
As the code can be updated, make it's more reliable to check the available options directly in the script using the --help flag.
> Notes: The script location depends where you cloned the repository.
> As some tasks need sudo permission, you may need to enter your password during the script execution.

```shell
~/dotfiles/init.sh --help
```

> <name_of_init_script>  can be one of the files in the scripts/zsh/init folder without the extension.

- **-y|--yes| -Y** : accepts all packages installation licenses

- **--skip**: Skip the already runned tasks

- **--skip-<name_of_init_script>** :  You set the skip flag for the individual scripts if needed.

- **--<name_of_init_script>** : Run only the specified init script
- **--skip_package_installation** : Skip the package manager installation
- **--skip_update** : Skip the package manager update and upgrade
- **--additional-packages** : Install additional that are not in the package manager
- **--help** : Will print the available options to run the script

## Project structure

- [**init.sh**](https://github.com/dev-vinicius-andrade/dotfiles/init.sh)     Script to install all dependencies and set up the environment
- [**.zshrc**](https://github.com/dev-vinicius-andrade/dotfiles/.zshrc)       Zsh configuration file
- [**.zshenv**](https://github.com/dev-vinicius-andrade/dotfiles/.zshenv)     Zsh Public environment variables
- [**alacritty**](https://github.com/dev-vinicius-andrade/dotfiles/alacritty) Alacritty configuration files and themes
- [**nushell**](https://github.com/dev-vinicius-andrade/dotfiles/)            Nushell configuration files
- [**nvim**](https://github.com/dev-vinicius-andrade/dotfiles/)               Neovim configuration files/plugins
- [**starship**](https://github.com/dev-vinicius-andrade/dotfiles/)           Starship configuration files
- [**tmux**](https://github.com/dev-vinicius-andrade/dotfiles/)               Tmux configuration files
- [**zsh**](https://github.com/dev-vinicius-andrade/dotfiles/)                Zsh configuration files
- [**scripts**](https://github.com/dev-vinicius-andrade/dotfiles/)            Scripts to automate the environment setup
- [**wezterm**](https://github.com/dev-vinicius-andrade/dotfiles/)            Wezterm configuration files
- [**nushell**](https://github.com/dev-vinicius-andrade/dotfiles/)            Nushell configuration files
