# Darwin-specific system packages
{pkgs, unstablePkgs, ...}: {
  imports = [
    ../shared/packages.nix  # Import cross-platform packages
  ];

  environment.systemPackages = with pkgs; [
    # macOS-specific tools
    karabiner-elements  # macOS keyboard customization
    mysides            # macOS Finder sidebar management
    p4v               # Perforce GUI (often used on macOS dev machines)

    # macOS-specific utilities
    # Add other Darwin-only packages here

    # Darwin-compatible packages that might not work on Linux:
    # unstablePkgs.openscad  # 3D modeling (GUI app)
  ];
}