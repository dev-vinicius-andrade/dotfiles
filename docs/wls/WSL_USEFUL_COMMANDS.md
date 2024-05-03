# WSL USEFUL COMMANDS

In this document, we will list some useful commands to manage WSL distributions.
For more information, you can visit the official documentation [here](https://docs.microsoft.com/en-us/windows/wsl/).
All the examples are based on Ubuntu 24.04, but you can replace it with your distribution.
You can also download the WSL distributions from the Microsoft Store

## List all the installed distributions

```bash
wsl --list
```

## List available online distributions

```bash
wsl --list --online
```

## Recreate WSL distribution

```powershell
wslconfig.exe /U Ubuntu-24.04;ubuntu2404.exe
```



## Create the symlink dotfiles on Windows Host

### Using Defaults

```bash
ln -sn "$(wslpath $(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null) | tr -d '\r')/dotfiles" ~/dotfiles && \
chmod +x ~/dotfiles/init.sh && \
~/dotfiles/init.sh -y
```

### Using Homebrew

```bash
ln -sn "$(wslpath $(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null) | tr -d '\r')/dotfiles" ~/dotfiles && \
chmod +x ~/dotfiles/init.sh && \
~/dotfiles/init.sh -y --use-homebrew
```
