# Main Darwin module - imports all Darwin-specific configuration
{...}: {
  imports = [
    ./system.nix
    ./packages.nix
    ./homebrew.nix
    ./macos-defaults.nix
    ./fonts.nix
  ];
}
