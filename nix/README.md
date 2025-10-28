# Nix Dotfiles

Personal dotfiles configuration using Nix flakes for macOS (Darwin) and Linux systems.

## Features

- **Cross-platform**: Supports both macOS (via nix-darwin) and Linux (NixOS)
- **Modular design**: Organized into focused modules for easy maintenance
- **Host-specific overrides**: Per-machine customization without code duplication
- **Homebrew integration**: Declarative macOS app management via nix-homebrew
- **Home Manager**: User-level configuration management
- **SOPS integration**: Secure secrets management

## Quick Start

### Prerequisites

1. Install Nix with flakes support:

   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. Install Task runner:

   ```bash
   # macOS
   brew install go-task
   # or via Nix
   nix profile install nixpkgs#go-task
   ```

### Initial Setup (macOS)

1. Clone this repository:

   ```bash
   git clone <repository-url> ~/.config/nix-dotfiles
   cd ~/.config/nix-dotfiles/nix
   ```

2. Build the configuration:

   ```bash
   task build-mac
   ```

3. Apply the configuration:

   ```bash
   task apply-mac-flake
   ```

## Available Commands

| Command | Description |
|---------|-------------|
| `task build-mac` | Build Darwin configuration for current host |
| `task dry-run-mac` | Test configuration changes without applying |
| `task apply-mac-flake` | Apply Darwin configuration to system |
| `task update` | Update channels, flake, and apply changes |
| `task gc` | Garbage collect old generations |
| `statix check .` | Lint Nix files (lux host only) |
| `nix flake check` | Validate flake configuration |

## Repository Structure

```
├── flake.nix              # Main flake configuration
├── hosts/                 # Host-specific configurations
│   ├── darwin/
│   │   ├── lux/           # Personal development machine
│   │   ├── mac/           # Generic macOS template
│   │   └── work-macbook/  # Work machine
│   └── linux/
│       └── bastion/       # Linux server
├── modules/
│   ├── darwin/            # macOS-specific modules
│   ├── nixos/             # Linux-specific modules
│   ├── shared/            # Cross-platform packages
│   ├── home/              # Home Manager modules
│   └── flake/             # Flake configuration modules
└── home/                  # User-specific configurations
    ├── gwelican.nix
    └── pvarsanyi.nix
```

## Adding a New Host

1. Create a new directory in `hosts/darwin/` or `hosts/linux/`
2. Add a `default.nix` file with host-specific overrides
3. The flake automatically detects and configures the host based on directory name

Example host configuration:

```nix
{ config, pkgs, ... }: {
  # Host-specific homebrew apps
  homebrew.casks = [
    "work-app"
  ];
  
  # Host-specific system packages
  environment.systemPackages = with pkgs; [
    # custom tools
  ];
}
```

## Code Style Guidelines

- **File naming**: Use kebab-case (e.g., `macos-defaults.nix`)
- **Module structure**: Split functionality into focused modules
- **Comments**: Use `#` for documentation, explain purpose not implementation
- **Host overrides**: Place in `hosts/{platform}/{hostname}/default.nix`
- **Shared packages**: Use `modules/shared/packages.nix` for cross-platform tools

## Security

- Secrets are managed via SOPS (not committed to repository)
- `secrets.nix` pattern is gitignored
- Use `lib.mkIf` for conditional configuration

## Troubleshooting

### Build Issues

- Run `task dry-run-mac` to test changes before applying
- Use `nix flake check` to validate configuration
- Check `statix check .` for linting issues (on lux host)

### Permission Issues

- Ensure proper sudo configuration for nix-darwin
- Check system integrity protection settings on macOS

## Contributing

1. Test changes with `task dry-run-mac`
2. Follow existing code style patterns
3. Update documentation for significant changes
4. Use conventional commit messages

#### Future improvements

Agenix secret manager
Alejandra nix formatting

