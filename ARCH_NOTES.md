# Arch Linux Implementation Notes

This document provides detailed information about the Arch Linux branch of Omakub, including implementation details, known issues, and troubleshooting tips.

## Overview

The Omakub Arch branch brings the opinionated development environment setup from Ubuntu to Arch Linux and Arch-based distributions. It maintains the same philosophy and goals while adapting to Arch's rolling release model and package management system.

## Key Differences from Ubuntu Version

### Package Management

**Ubuntu:**
- Uses apt with PPAs for additional packages
- Specific version checking (Ubuntu 24.04+)
- Stable release cycle

**Arch:**
- Uses pacman for official repositories
- Uses paru (AUR helper) for community-maintained packages
- Rolling release model (always up-to-date)
- No version checking needed

### Bootstrap Process

The `boot.sh` script:
1. Updates the system with `pacman -Syu`
2. Installs base development tools (`base-devel`, `git`)
3. **Installs paru from AUR** (compiled from source via makepkg)
4. Clones Omakub to `~/.local/share/omakub`
5. Runs the interactive installer

### paru Installation

Since paru is only available in AUR, it must be built from source during bootstrap:

```bash
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
```

This is automated in `boot.sh` and requires `base-devel` to be installed first.

## Distribution Support

This branch officially supports:

- **Arch Linux** - The main distribution
- **CachyOS** - Arch-based with custom kernel optimization
- **Manjaro** - Arch-based with stability focus

Detection uses both `ID` and `ID_LIKE` fields from `/etc/os-release`:

```bash
if [[ "$ID" == "arch" ]] || [[ "$ID_LIKE" == *"arch"* ]]; then
  # Run Arch installation
fi
```

This approach allows the installer to detect any Arch-based distribution.

## Known Issues and Solutions

### Issue: gnome-sushi not found

**Symptom:** Installation fails during `install/desktop/app-gnome-sushi.sh`

**Cause:** `gnome-sushi` package availability varies across Arch repositories

**Solution:** The script uses error suppression:
```bash
paru -S --noconfirm gnome-sushi 2>/dev/null || true
```

Installation continues even if the package is unavailable.

### Issue: paru build times

**Symptom:** Long wait during first `boot.sh` run while paru is compiled

**Cause:** paru must be compiled from source (AUR package)

**Workaround:** The process shows progress spinners. Consider:
- Running on systems with adequate CPU resources
- Waiting 5-15 minutes depending on hardware
- Using pre-built AUR snapshots if available

### Issue: Docker permission denied

**Symptom:** Can't use Docker without `sudo` after installation

**Cause:** User must log out and back in for group membership changes

**Solution:** Log out and back in (or restart) after Docker installation

### Issue: GNOME extensions compatibility

**Symptom:** Some GNOME extensions fail to install or work

**Cause:** Extension compatibility varies by GNOME version

**Solution:**
- Check extension requirements on GNOME Extensions website
- Use `extension-manager` GUI to manage extensions safely
- Some extensions may need updating for your GNOME version

### Issue: AUR package conflicts

**Symptom:** paru reports package conflicts during AUR builds

**Cause:** Some AUR packages have dependencies or conflicts

**Solution:**
- Check AUR comments for known issues
- Try removing conflicting package first
- Report to AUR maintainer if reproducible

## Package Availability Reference

### Official Repos - Always Available

These packages are available in official Arch repositories:

```
base-devel autoconf bison clang rust python-pipx
openssl readline zlib libyaml ncurses libffi gdbm jemalloc
libvips imagemagick mupdf mupdf-tools
redis sqlite mariadb-libs postgresql-libs postgresql
docker docker-compose docker-buildx
git curl unzip
neovim tmux alacritty
gnome-tweaks gnome-shell-extensions gnome-software
vlc libreoffice-fresh obs-studio
flatpak fzf ripgrep bat eza zoxide
```

### AUR - Varies by Distribution

These packages are in AUR and availability varies:

```
google-chrome          - Browser
visual-studio-code-bin - Code editor
brave-bin             - Browser
1password             - Password manager
zoom                  - Video conferencing
signal-desktop        - Messaging
spotify               - Music streaming
windsurf-bin          - AI editor
ulauncher             - Application launcher
```

### Potentially Unavailable

Some packages may not be in all distributions:

- `gnome-sushi` - File previews (may be missing)
- Newer AUR packages - Availability depends on AUR status
- Distribution-specific packages - (e.g., Manjaro has additional repos)

## Installation Patterns

### Using pacman (Official Repos)

```bash
sudo pacman -S --noconfirm package-name
```

Multiple packages:
```bash
sudo pacman -S --noconfirm package1 package2 package3
```

Uninstall (remove):
```bash
sudo pacman -R --noconfirm package-name
```

Uninstall with dependencies:
```bash
sudo pacman -Rns --noconfirm package-name
```

### Using paru (AUR)

```bash
paru -S --noconfirm package-name
```

The `--noconfirm` flag skips prompts for automated installation.

### Checking Package Availability

```bash
# Official repos
pacman -Ss search-term

# AUR
paru -Ss search-term
```

### Version Management

Most development tools use mise (version manager):

```bash
mise use --global ruby@latest    # Ruby
mise use --global node@lts       # Node.js
mise use --global go@latest      # Go
```

This is preferable to system-wide package installation for languages.

## Troubleshooting Commands

### Check if system is Arch-based
```bash
cat /etc/os-release | grep -E "^ID"
```

Expected output:
- `ID=arch` for Arch Linux
- `ID=cachyos` for CachyOS
- `ID=manjaro` for Manjaro

### Check installed version of a package
```bash
pacman -Q package-name
```

### Force reinstall a package
```bash
sudo pacman -S --force --noconfirm package-name
```

### List files from a package
```bash
pacman -Ql package-name
```

### Find which package owns a file
```bash
pacman -F /path/to/file
```

### Clean up unused packages
```bash
sudo pacman -Rns $(pacman -Qdtq)
```

### Update all packages
```bash
sudo pacman -Syu
```

## Adding New Applications

When adding a new application to the installer:

1. **Check package availability:**
   ```bash
   pacman -Ss app-name      # Official repos
   paru -Ss app-name        # AUR
   ```

2. **Create installer script** at `/install/desktop/app-name.sh` or `/install/terminal/app-name.sh`

3. **Use pacman or paru as appropriate:**
   - Official: `sudo pacman -S --noconfirm package-name`
   - AUR: `paru -S --noconfirm package-name`

4. **Handle optional packages with error suppression:**
   ```bash
   paru -S --noconfirm optional-package 2>/dev/null || true
   ```

5. **Create corresponding uninstall script** at `/uninstall/app-name.sh`:
   ```bash
   #!/bin/bash
   sudo pacman -R --noconfirm package-name
   ```

6. **Add to selection menu** if user-optional

## Performance Tips

### Reduce build times
- Use mirrors geographically close to you
- Enable parallel downloads in `/etc/pacman.conf`:
  ```ini
  ParallelDownloads = 5
  ```

### Speed up paru AUR builds
- Install faster compiler: `ccache` or `clang`
- Pre-install dependencies before building
- Use `-Bh` flag to build in RAM (if you have 4GB+ available)

### System updates
- Run `pacman -Syu` before starting Omakub installation
- This reduces conflicts during initial setup

## Testing the Installation

### On a VM
1. Use VirtualBox or QEMU with Arch ISO
2. Allocate 4GB RAM, 20GB disk minimum
3. Install fresh Arch with GNOME
4. Run `bash <(curl -fsSL https://raw.githubusercontent.com/stadia/omakub/arch/boot.sh)`

### On CachyOS
1. Install fresh CachyOS with GNOME
2. Run the same installation command
3. Should work identically to Arch

### On Manjaro
1. Install fresh Manjaro with GNOME
2. Run the installation command
3. May have additional packages available in Manjaro repos

## Contributing

When working on the Arch branch:

1. **Test changes** on a fresh Arch/CachyOS VM
2. **Document package differences** if renaming/replacing Ubuntu packages
3. **Use error suppression** (`2>/dev/null || true`) for optional packages
4. **Update CLAUDE.md** with new package mappings
5. **Report issues** with specific distributions (Arch vs CachyOS vs Manjaro)

## Related Files

- `boot.sh` - Initial bootstrap with paru installation
- `install/check-version.sh` - OS detection logic
- `CLAUDE.md` - Package mapping reference
- `README.md` - User-facing installation guide

## References

- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [AUR Guidelines](https://wiki.archlinux.org/title/AUR_submission_guidelines)
- [paru GitHub](https://github.com/morganamilo/paru)
- [pacman Manual](https://man.archlinux.org/man/pacman.8)
