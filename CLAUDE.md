# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Omakub is an opinionated setup tool that transforms a fresh Ubuntu 24.04+ installation into a fully-configured development system. It installs and configures terminal tools, programming languages, databases, and optional desktop applications through an interactive UI (using Gum, a terminal UI framework).

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
- Manual testing on fresh Ubuntu 24.04 VMs is the primary validation method
- Shell script best practices: quote variables, avoid globbing in loops, handle paths with spaces
- Desktop installers should verify GNOME is running before executing GNOME-specific configuration

## Release Management

- Version is stored in `/version` file
- Releases are tagged on the git repository
- `stable` branch tracks the latest stable release
- `master` branch is the development branch
