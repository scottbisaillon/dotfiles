#Requires -Version 5.1
<#
.SYNOPSIS
    Symlink dotfiles from this repo into their Windows config locations.

.DESCRIPTION
    Creates symbolic links so the deployed config *is* the repo file - edit either
    side and it's the same file, making this repo the source of truth. Re-runnable:
    correct links are left alone, stale links are repaired, and real files already in
    place are backed up (with -Force) rather than clobbered.

    Requires Windows Developer Mode (enabled on this machine) or an elevated shell,
    since creating symlinks otherwise needs admin rights.

.PARAMETER DryRun
    Print what would happen without changing anything.

.PARAMETER Force
    When a target already exists as a real (non-symlink) file/dir, back it up to
    "<name>.bak-<timestamp>" and replace it with the link. Without this, such targets
    are skipped with a warning.

.EXAMPLE
    .\install.ps1 -DryRun
    .\install.ps1
    .\install.ps1 -Force
#>
[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot

# Source (relative to this repo) -> Target (absolute). Type: Dir links the whole
# folder; File links a single file. Unix-only apps (kitty, tmux, zellij) are omitted
# on Windows - add entries here if you start using them under WSL.
$links = @(
    @{ Source = 'nvim';                   Target = "$env:LOCALAPPDATA\nvim";                 Type = 'Dir'  }
    @{ Source = 'alacritty';              Target = "$env:APPDATA\alacritty";                 Type = 'Dir'  }
    @{ Source = 'starship\starship.toml'; Target = "$env:USERPROFILE\.config\starship.toml"; Type = 'File' }
    @{ Source = 'wezterm\.wezterm.lua';   Target = "$env:USERPROFILE\.wezterm.lua";          Type = 'File' }
)

function Write-Status($symbol, $color, $message) {
    Write-Host "  $symbol " -ForegroundColor $color -NoNewline
    Write-Host $message
}

function Test-IsSymlink($path) {
    if (-not (Test-Path -LiteralPath $path)) { return $false }
    $item = Get-Item -LiteralPath $path -Force
    return [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function Get-LinkTarget($path) {
    (Get-Item -LiteralPath $path -Force).Target | Select-Object -First 1
}

function Resolve-Same($a, $b) {
    if (-not $a -or -not $b) { return $false }
    return [IO.Path]::GetFullPath($a).TrimEnd('\') -ieq [IO.Path]::GetFullPath($b).TrimEnd('\')
}

Write-Host "`nLinking dotfiles from $repo" -ForegroundColor Cyan
if ($DryRun) { Write-Host "(dry run - no changes will be made)" -ForegroundColor DarkGray }
Write-Host ""

foreach ($link in $links) {
    $src = Join-Path $repo $link.Source
    $tgt = $link.Target
    $name = $link.Source

    if (-not (Test-Path -LiteralPath $src)) {
        Write-Status '!' Yellow "$name -> source missing in repo, skipping"
        continue
    }

    # Already a symlink? Check whether it points where we want.
    if (Test-IsSymlink $tgt) {
        if (Resolve-Same (Get-LinkTarget $tgt) $src) {
            Write-Status '=' DarkGray "$name -> already linked"
            continue
        }
        Write-Status '~' Yellow "$name -> relinking (was pointing elsewhere)"
        if (-not $DryRun) { Remove-Item -LiteralPath $tgt -Force -Recurse }
    }
    elseif (Test-Path -LiteralPath $tgt) {
        # A real file/dir sits at the target.
        if (-not $Force) {
            Write-Status '!' Yellow "$name -> real file exists at target; use -Force to back up and replace"
            continue
        }
        $backup = "$tgt.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
        Write-Status '~' Yellow "$name -> backing up existing target to $(Split-Path $backup -Leaf)"
        if (-not $DryRun) { Move-Item -LiteralPath $tgt -Destination $backup }
    }

    # Ensure the parent directory exists (e.g. ~\.config for starship).
    $parent = Split-Path -Parent $tgt
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        if (-not $DryRun) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    }

    if ($DryRun) {
        Write-Status '+' Green "$name -> would link to $tgt"
        continue
    }

    try {
        New-Item -ItemType SymbolicLink -Path $tgt -Target $src -Force | Out-Null
        Write-Status '+' Green "$name -> $tgt"
    }
    catch {
        Write-Status 'x' Red "$name -> failed: $($_.Exception.Message)"
        Write-Host "      (symlinks need Developer Mode or an elevated shell)" -ForegroundColor DarkGray
    }
}

Write-Host "`nDone.`n" -ForegroundColor Cyan
