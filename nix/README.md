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


## CI (Woodpecker)

Jobs live in `.woodpecker/` at the repository root and run on the self-hosted Woodpecker
server (`https://woodpecker.gwelican.eu`), whose agent uses the Kubernetes backend — so
every step runs on `x86_64-linux` in `nixpkgs/nix-flakes:nixos-25.11-x86_64-linux`
(the image matches the nixpkgs branch pinned in `flake.lock`).

| Job | File | What it proves |
| --- | --- | --- |
| `nix-check` | `.woodpecker/nix.yaml` | `nix flake check --impure --all-systems`, `nix build .#nixosConfigurations.bastion.config.system.build.toplevel` (a real Linux system build), `nix eval` of `.#darwinConfigurations.lux.system` and `.mac.system` |
| `lint` | `.woodpecker/lint.yaml` | yamllint (`.github/lint/.yamllint.yaml`), `nix fmt -- --ci` |

`task check` runs the host-safe subset locally (darwin eval, `nix fmt -- --ci`, plus a
non-blocking `statix check`). statix reports warnings on the current tree, so it stays
advisory rather than a gate.

### Required secret

The flake decrypts `nix/secrets.sops.yaml` **during evaluation**
(`builtins.readFile` of the `secrets-json` derivation in `modules/flake/*.nix`), so every
nix step needs `SOPS_AGE_KEY_FILE` — without the key the flake fails to evaluate, not
merely to build. Woodpecker needs one repo secret:

- `SOPS_AGE_KEY` — the age key that decrypts `nix/secrets.sops.yaml`

Add it in Woodpecker → repository → Secrets (plain/env type). The pipeline writes it to
`nix/age.key` and exports `SOPS_AGE_KEY_FILE` for the checks. Activate the repository in
Woodpecker (Admin → Repositories → `gwelican/dotfiles`).

### Limits

- **Mac coverage is eval-only.** Building `aarch64-darwin` requires a macOS host and the
  agent has no macOS runner, so CI evaluates the darwin configs to a derivation path on
  Linux. That catches module/option errors, not build failures, not the homebrew casks.
  Use `task build-mac` (and `task dry-run-mac`) on the Mac itself for the build.
- **Key lands in the runner store.** The flake passes the age key as `SOPS_AGE_KEY` env of
  the `secrets-json` derivation, so the key ends up in a `.drv` inside the runner's nix
  store, readable by anyone with the store. Keep the runner on the bastion cluster.

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

