# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Arch Linux Branch**: This is the Arch Linux port of Omakub. For Ubuntu 24.04+ documentation, see the [master branch](https://github.com/basecamp/omakub/tree/master).

Omakub is an opinionated setup tool that transforms a fresh Arch Linux installation into a fully-configured development system. It installs and configures terminal tools, programming languages, databases, and optional desktop applications through an interactive UI (using Gum, a terminal UI framework).

### Arch Linux Differences

This branch (`arch`) differs from the Ubuntu version in several ways:

- **Package Manager**: Uses `pacman` (official Arch repos) and `paru` (AUR) instead of apt
- **Distribution Support**: Works on Arch Linux and Arch-based distributions (CachyOS, Manjaro, etc.)
- **Rolling Release**: No version checking required (unlike Ubuntu's release-specific approach)
- **Bootstrap**: Automatically installs `paru` on first run
- **Package Names**: Many packages have different names in Arch (e.g., `gnome-tweaks` vs `gnome-tweak-tool`)

## Architecture Overview

### High-Level Flow

1. **Initial Installation (`boot.sh`)**: User runs a one-line command that downloads and executes `boot.sh`
2. **First-Run Setup (`install.sh`)**: Asks user for language, database, and optional app selections via interactive prompts
3. **Component Installation**: Runs installer scripts in `/install/terminal/` and `/install/desktop/` directories
4. **Post-Install Menu (`omakub` command)**: Users can update apps, manage themes/fonts, install additional tools, or run migrations

### Directory Structure

- **`/install/terminal/`**: Terminal application installers (Ruby, Node.js, databases, CLI tools)
  - `required/`: Apps installed on every setup (gum, git, curl, unzip)
  - `optional/`: Apps users select during install (ollama, tailscale, geekbench)
  - Subdirectories like `app-*.sh` follow a pattern: download from GitHub releases, install to `/usr/local/bin`, create config directories
- **`/install/desktop/`**: GUI application installers (VSCode, Discord, VLC, etc.) - only runs if GNOME detected
- **`/bin/omakub`** and **`/bin/omakub-sub/`**: Post-install menu system and subcommands (theme, font, update, install, uninstall, manual, migrate)
- **`/migrations/`**: Timestamped migration scripts (named with Unix timestamp) run during updates to maintain system state
- **`/configs/`**: Configuration templates (bashrc, neovim config, VSCode settings, etc.) symlinked to user's home directory
- **`/uninstall/`**: Uninstall scripts for desktop applications (reverse of install)
- **`/themes/`**: GNOME theme definitions
- **`/applications/`**: Desktop application definition files for custom web apps

### Key Technologies

- **Gum**: Terminal UI framework used for interactive menus and confirmations
- **Mise**: Version manager for programming languages (replaces asdf); installed as foundational tool
- **Docker**: Optional for running databases without system-wide installation
- **GNOME**: Desktop environment support - desktop installers only run if GNOME is detected

## Common Development Tasks

### Testing Changes Locally

Since this is a bash-based installation tool meant for fresh Ubuntu systems, testing is limited. Common approaches:

1. **Syntax checking**: `bash -n install/terminal/app-*.sh` to validate shell syntax
2. **Manual testing**: Run on a fresh Ubuntu 24.04 VM or container
3. **Testing specific installers**: Source individual scripts to test: `source install/terminal/app-neovim.sh`

### Adding a New Application Installer

1. Create `/install/terminal/app-name.sh` or `/install/desktop/app-name.sh`
2. Follow the pattern from existing installers (e.g., `app-lazygit.sh`):
   - Download from GitHub releases using latest version detection via API
   - Extract and install to `/usr/local/bin` or appropriate location
   - Create configuration directories (e.g., `~/.config/app-name/`)
3. Add selection to `/install/first-run-choices.sh` if it should be offered during initial install
4. Create corresponding uninstall script in `/uninstall/app-name.sh` if it's a desktop app

### Adding a New Subcommand

1. Create `/bin/omakub-sub/subcommand-name.sh`
2. Add option to the `gum choose` menu in `/bin/omakub-sub/menu.sh`
3. The menu will automatically source your script when selected

### Adding a Configuration File

1. Add the configuration template to `/configs/`
2. Create an installer script that symlinks the config file to the user's home directory (see `app-alacritty.sh` or `app-neovim.sh` for examples)

### Creating a Migration

Migrations allow updates to existing installations without requiring a fresh install:

1. Create `/migrations/TIMESTAMP.sh` where TIMESTAMP is the current Unix timestamp
2. Add logic to update user configurations, install new dependencies, or restructure files
3. Migration scripts are automatically discovered and run by the `migrate.sh` subcommand
4. Keep migrations idempotent (safe to run multiple times)

## Important Patterns

### Variable Usage

- `$OMAKUB_PATH`: Set to `~/.local/share/omakub` during installation; used throughout scripts to reference the repository location
- `$XDG_CURRENT_DESKTOP`: Check for GNOME support with `[[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]`
- Environment variables from first-run choices (e.g., `OMAKUB_FIRST_RUN_LANGUAGES`) are passed to install scripts

### Error Handling

- Scripts use `set -e` to exit immediately on errors
- Initial install wraps the main installation in a trap to show retry instructions on failure
- Use `>/dev/null` to suppress verbose output during automated installations

### User Interaction

- Use `gum choose` for menus (single select) or `gum choose --no-limit` for multiple select
- Use `gum confirm` for yes/no confirmations
- Use `gum spin` for showing progress spinners

### Installation Patterns

For version-managed tools:
- Use `mise use --global <tool>@<version>` (typically `@latest` or `@lts`)
- Check `/install/terminal/select-dev-language.sh` for language-specific setup patterns

For static binaries from GitHub:
- Query GitHub API for latest release: `curl -s "https://api.github.com/repos/<owner>/<repo>/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'`
- Download and extract to temp directory, then install to `/usr/local/bin`
- See `app-lazygit.sh` and `app-neovim.sh` for examples

## Testing and Quality

- No automated test suite exists (Omakub is meant for fresh installs)
- Manual testing on fresh Arch Linux VMs or Arch-based distributions is the primary validation method
- Shell script best practices: quote variables, avoid globbing in loops, handle paths with spaces
- Desktop installers should verify GNOME is running before executing GNOME-specific configuration

## Arch Linux Package Mappings

When porting installers from Ubuntu to Arch, refer to these common package name changes:

| Ubuntu Package | Arch Package | Notes |
|---|---|---|
| `build-essential` | `base-devel` | Build tools and compiler |
| `libssl-dev` | `openssl` | OpenSSL development files |
| `libreadline-dev` | `readline` | readline library |
| `zlib1g-dev` | `zlib` | compression library |
| `libyaml-dev` | `libyaml` | YAML parsing library |
| `libncurses5-dev` | `ncurses` | Terminal UI library |
| `libffi-dev` | `libffi` | Foreign function interface |
| `libgdbm-dev` | `gdbm` | Database library |
| `libjemalloc2` | `jemalloc` | Memory allocator |
| `libmagickwand-dev` | `imagemagick` | Image processing |
| `redis-tools` | `redis` | Redis server |
| `libsqlite3-0` | `sqlite` | SQLite database |
| `fd-find` | `fd` | Fast find alternative |
| `apache2-utils` | `apache` | Apache utilities |
| `gnome-tweak-tool` | `gnome-tweaks` | GNOME settings manager |
| `gnome-shell-extension-manager` | `extension-manager` | Extension manager for GNOME |
| `gir1.2-gtop-2.0` | `libgtop` | System monitoring library |
| `gir1.2-clutter-1.0` | `clutter` | Animation framework |

## Arch-Specific Notes

### Available in Official Repos vs AUR

- **Official Repos (`pacman -S`)**: Most common tools like neovim, tmux, alacritty, vlc, etc.
- **AUR (`paru -S`)**: Newer/specialized tools like google-chrome, visual-studio-code-bin, 1password, zoom, etc.
- Some packages may not be available everywhere (e.g., `gnome-sushi` may not be in all Arch repositories)

### Optional Package Handling

For packages that may not be available in all Arch-based distributions, use error suppression:

```bash
paru -S --noconfirm optional-package 2>/dev/null || true
```

This allows installation to continue even if the package isn't found.

### Distribution Compatibility

This branch supports:
- Arch Linux (main distribution)
- CachyOS (Arch-based with custom kernel)
- Manjaro (Arch-based with stability focus)
- Other Arch-based distributions

Check `/etc/os-release` with both `ID` and `ID_LIKE` fields to detect Arch-based systems:

```bash
if [[ "$ID" == "arch" ]] || [[ "$ID_LIKE" == *"arch"* ]]; then
  # Arch-compatible system
fi
```

## Release Management

- Version is stored in `/version` file
- Releases are tagged on the git repository
- `arch` branch is the Arch Linux development branch
- `master` branch is the Ubuntu development branch
