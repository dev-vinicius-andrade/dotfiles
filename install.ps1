#Requires -Version 7
<#
  Windows bootstrap (counterpart of init.sh).
    pwsh -File install.ps1            # install tools, enable git hooks, link
    pwsh -File install.ps1 -NoInstall # only hooks + links
  Symlinks need Developer Mode (Settings > System > For developers) or an
  elevated shell; otherwise links are copied (envmgr --copy).
#>
param([switch]$NoInstall)
$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot

$packages = @(
    'Git.Git', 'Neovim.Neovim', 'Starship.Starship', 'sxyazi.yazi', 'ajeetdsouza.zoxide',
    'junegunn.fzf', 'sharkdp.fd', 'BurntSushi.ripgrep.MSVC', 'sharkdp.bat', 'eza-community.eza',
    'JesseDuffield.lazygit', 'Schniz.fnm', 'Mozilla.SOPS', 'FiloSottile.age', 'Gitleaks.Gitleaks',
    'Kubernetes.kubectl', 'Helm.Helm', 'Derailed.k9s', 'ahmetb.kubectx', 'Atuinsh.Atuin',
    'wez.wezterm', 'jqlang.jq', 'MikeFarah.yq', 'DEVCOM.JetBrainsMonoNerdFont'
)

if (-not $NoInstall) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'winget not found (install "App Installer" from the Store)' }
    foreach ($id in $packages) {
        Write-Host "==> $id"
        winget install --id $id --exact --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) { Write-Warning "winget could not install $id (already installed or not available), continuing" }
    }
}

git -C $repo config core.hooksPath .githooks
Write-Host 'git hooks enabled (gitleaks pre-commit)'

if (Get-Command envmgr -ErrorAction SilentlyContinue) {
    envmgr dotfiles register $repo
    $devMode = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense -eq 1
    if ($devMode) { envmgr dotfiles link } else { envmgr dotfiles link --copy }
} else {
    Write-Warning 'envmgr not found: install it (https://github.com/dev-vinicius-andrade/environment-manager) and run `envmgr dotfiles link`'
}

if (Get-Command ya -ErrorAction SilentlyContinue) { ya pkg install }  # yazi plugins from yazi/package.toml
Write-Host 'Done. Restart the terminal.'
