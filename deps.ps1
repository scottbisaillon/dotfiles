#Requires -Version 5.1
<#
.SYNOPSIS
    Install the CLI tools this dotfiles setup relies on, via winget.

.DESCRIPTION
    Installs the command-line tools the configs in this repo shell out to but can't
    manage themselves (nvim's vim.pack handles plugins; this handles the binaries
    those plugins invoke). Idempotent: a tool already on PATH - from any source
    (scoop, winget, manual) - is detected and skipped, so nothing gets duplicated.

    Needs no admin and no PowerShell 7; plain Windows PowerShell is fine. After it
    runs, open a new shell so PATH updates are picked up.

    Scope is tools and assets the configs need - CLI utilities, a C compiler for
    treesitter, and the Nerd Font. Language runtimes (Node, Python, ...) are
    intentionally excluded; add those yourself only if you pull in a Mason server or
    formatter that requires one.

.PARAMETER DryRun
    Print what would be installed without changing anything.

.EXAMPLE
    .\deps.ps1 -DryRun
    .\deps.ps1
#>
[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

# Id:  winget package id (verified with `winget search --id <id> --exact`).
# Cmd: the executable it provides, used to detect an existing install from ANY
#      source (scoop, winget, manual) so we never reinstall over an existing tool.
#      Omit for packages with no command (fonts) - those fall back to winget's registry.
$packages = @(
    @{ Id = 'Neovim.Neovim';                Name = 'Neovim';                  Cmd = 'nvim' }  # the editor itself
    @{ Id = 'Git.Git';                      Name = 'Git';                     Cmd = 'git'  }  # vim.pack clones plugins over git
    @{ Id = 'zig.zig';                      Name = 'Zig (C compiler)';        Cmd = 'zig'  }  # nvim-treesitter compiles parsers via `zig cc`
    @{ Id = 'BurntSushi.ripgrep.MSVC';      Name = 'ripgrep (rg)';            Cmd = 'rg'   }  # fast grep: live-grep / pickers
    @{ Id = 'sharkdp.fd';                   Name = 'fd';                      Cmd = 'fd'   }  # fast file finder
    @{ Id = 'DEVCOM.JetBrainsMonoNerdFont'; Name = 'JetBrainsMono Nerd Font'              }  # have_nerd_font + alacritty "JetBrainsMono NF"
)

function Write-Status($symbol, $color, $message) {
    Write-Host "  $symbol " -ForegroundColor $color -NoNewline
    Write-Host $message
}

function Test-Installed($pkg) {
    # Prefer detecting the command on PATH - catches installs from any source.
    if ($pkg.Cmd -and (Get-Command $pkg.Cmd -ErrorAction SilentlyContinue)) { return $true }
    # No command (e.g. a font): fall back to winget's registry, which exits
    # non-zero when nothing matches.
    if (-not $pkg.Cmd) {
        winget list --id $pkg.Id --exact --accept-source-agreements *> $null
        return ($LASTEXITCODE -eq 0)
    }
    return $false
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Install 'App Installer' from the Microsoft Store first." -ForegroundColor Red
    exit 1
}

Write-Host "`nInstalling CLI tools via winget" -ForegroundColor Cyan
if ($DryRun) { Write-Host "(dry run - no changes will be made)" -ForegroundColor DarkGray }
Write-Host ""

$failed = @()

foreach ($pkg in $packages) {
    $label = "$($pkg.Name) [$($pkg.Id)]"

    if (Test-Installed $pkg) {
        Write-Status '=' DarkGray "$label -> already installed"
        continue
    }

    if ($DryRun) {
        Write-Status '+' Green "$label -> would install"
        continue
    }

    Write-Status '+' Green "$label -> installing..."
    winget install --id $pkg.Id --exact --source winget `
        --accept-source-agreements --accept-package-agreements --disable-interactivity

    if ($LASTEXITCODE -ne 0) {
        Write-Status 'x' Red "$label -> winget exit code $LASTEXITCODE"
        $failed += $pkg.Name
    }
}

Write-Host ""
if ($failed.Count -gt 0) {
    Write-Host "Finished with errors: $($failed -join ', ')" -ForegroundColor Yellow
    exit 1
}
Write-Host "Done. Open a new shell so PATH updates take effect." -ForegroundColor Cyan
Write-Host ""
exit 0
