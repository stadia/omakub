# Omakub (Arch Linux Branch)

Turn a fresh Arch Linux installation into a fully-configured, beautiful, and modern web development system by running a single command. That's the one-line pitch for Omakub. No need to write bespoke configs for every essential tool just to get started or to be up on all the latest command-line tools. Omakub is an opinionated take on what Linux can be at its best.

**Note:** This is the Arch Linux branch. For Ubuntu 24.04+ support, see the [master branch](https://github.com/basecamp/omakub).

Watch the introduction video and read more at [omakub.org](https://omakub.org).

## Requirements

- Fresh Arch Linux installation (or Arch-based distribution like CachyOS, Manjaro)
- GNOME desktop environment (optional - terminal tools work without it)
- x86_64 or i686 architecture
- Internet connection

## Installation

To set up Omakub on a fresh Arch Linux system, run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/stadia/omakub/arch/boot.sh)
```

The installer will:
1. Update your system and install essential build tools
2. Install paru (AUR helper) for accessing additional packages
3. Clone Omakub to `~/.local/share/omakub`
4. Run the interactive installer menu

During installation, you'll be prompted to select:
- Programming languages (Ruby, Node.js, Go, PHP, Python, Elixir, Rust, Java)
- Optional development tools (Docker, databases, version managers)
- Optional desktop applications (VSCode, Discord, VLC, and many more)

## Contributing to the documentation

Please help us improve Omakub's documentation on the [basecamp/omakub-site repository](https://github.com/basecamp/omakub-site).

## License

Omakub is released under the [MIT License](https://opensource.org/licenses/MIT).

## Extras

While omakub is purposed to be an opinionated take, the open source community offers alternative customization, add-ons, extras, that you can use to adjust, replace or enrich your experience.

[⇒ Browse the omakub extensions.](EXTENSIONS.md)
