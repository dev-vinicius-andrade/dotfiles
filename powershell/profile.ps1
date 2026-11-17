# PowerShell 7 profile, the Windows counterpart of .zshenv + .zshrc.
# Linked by envmgr to ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
# (see .dotfiles.config.json). Every tool is optional; missing ones are skipped.

function Test-Command([string]$Name) { [bool](Get-Command $Name -ErrorAction SilentlyContinue) }

# --- dotfiles location (follows the profile symlink) ------------------------
$profileItem = Get-Item $PSCommandPath
$profileTarget = if ($profileItem.LinkTarget) { $profileItem.LinkTarget } else { $PSCommandPath }
$env:DOT_FILES_DIR = Split-Path -Parent (Split-Path -Parent $profileTarget)

# --- environment ------------------------------------------------------------
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'
# yazi on Windows needs `file` from Git for Windows to detect mime types
$gitFile = Join-Path $env:ProgramFiles 'Git\usr\bin\file.exe'
if (Test-Path $gitFile) { $env:YAZI_FILE_ONE = $gitFile }

# --- secrets: same sops file as zsh/secrets.zsh ------------------------------
# Key: %APPDATA%\sops\age\keys.txt (or set SOPS_AGE_KEY_FILE). Edit with: Edit-Secrets
$SopsSecretsFile = Join-Path $env:DOT_FILES_DIR 'secrets/env.sops.env'
function Import-Secrets {
    if (-not (Test-Path $SopsSecretsFile) -or -not (Test-Command sops)) { return }
    $lines = sops decrypt --input-type dotenv --output-type dotenv $SopsSecretsFile 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Warning "secrets: could not decrypt $SopsSecretsFile (age key missing?)"; return }
    foreach ($line in $lines) {
        if ($line -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') {
            Set-Item -Path "Env:$($Matches[1])" -Value $Matches[2]
        }
    }
}
function Edit-Secrets { sops edit $SopsSecretsFile; Import-Secrets }
Import-Secrets

# --- PSReadLine: zsh-autosuggestions-like behaviour --------------------------
if (Get-Module -ListAvailable PSReadLine) {
    Set-PSReadLineOption -EditMode Emacs -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# --- aliases / helpers -------------------------------------------------------
if (Test-Command eza) {
    # built-in aliases win over functions, so drop `ls` first
    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    function ls { eza --icons --group-directories-first @args }
    function ll { eza --icons --group-directories-first -l --git @args }
    function la { eza --icons --group-directories-first -la --git @args }
}
if (Test-Command lazygit) { Set-Alias lg lazygit }
if (Test-Command nvim) { Set-Alias v nvim }
if (Test-Command kubectl) {
    Set-Alias k kubectl
    if (Test-Command kubectx) { Set-Alias kctx kubectx }
    if (Test-Command kubens) { Set-Alias kns kubens }
}
function gopull([string]$Path = '.') { git -C $Path pull }

# yazi: `y` opens yazi and cd's to wherever you quit it
if (Test-Command yazi) {
    function y {
        $tmp = (New-TemporaryFile).FullName
        yazi @args --cwd-file="$tmp"
        $cwd = Get-Content -Path $tmp -Encoding UTF8
        if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
            Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
        }
        Remove-Item -Path $tmp
    }
}

# --- tool integrations -------------------------------------------------------
if (Test-Command fnm) { fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression }
if (Test-Command zoxide) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
    Set-Alias cd z -Option AllScope -Force
}
if (Test-Command starship) { Invoke-Expression (&starship init powershell) }
if (Test-Command atuin) {
    $env:ATUIN_POWERSHELL_PROMPT_OFFSET = 0
    atuin init powershell --disable-up-arrow | Out-String | Invoke-Expression
}

# machine-only additions (untracked)
$localProfile = Join-Path (Split-Path -Parent $PROFILE) 'profile.local.ps1'
if (Test-Path $localProfile) { . $localProfile }
