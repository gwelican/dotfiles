# Agent Guidelines for Nix Dotfiles

## Build/Test Commands
- `task build-mac` - Build Darwin configuration for current host
- `task dry-run-mac` - Test configuration changes without applying
- `task apply-mac-flake` - Apply Darwin configuration to system
- `statix check .` - Lint Nix files (available via homebrew on lux host)
- `nix flake check` - Validate flake configuration

## Code Style & Structure
- **File naming**: Use kebab-case (e.g., `macos-defaults.nix`)  
- **Imports**: Group by type - inputs first, then local modules
- **Comments**: Use `#` for documentation, explain purpose not implementation
- **Formatting**: Let `nixfmt` handle formatting, maintain consistent indentation
- **Module structure**: Split functionality into focused modules (system, packages, homebrew, etc.)

## Architecture Patterns
- **Host-specific config**: Place overrides in `hosts/{platform}/{hostname}/default.nix`
- **Shared packages**: Use `modules/shared/packages.nix` for cross-platform tools
- **Darwin-specific**: Use `modules/darwin/` for macOS-only configuration
- **Home Manager**: Configure user-level settings in `home/{username}.nix`

## Error Handling
- Use `lib.mkIf` for conditional configuration
- Set `ignore_error: true` in Taskfile for non-critical operations
- Test changes with dry-run before applying to system

## Security
- Never commit secrets - use SOPS or external secret management
- Maintain `.gitignore` with `secrets.nix` pattern