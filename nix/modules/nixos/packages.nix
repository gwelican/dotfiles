# Linux-specific system packages  
{pkgs, unstablePkgs, ...}: {
  imports = [
    ../shared/packages.nix  # Import cross-platform packages
  ];

  environment.systemPackages = with pkgs; [
    # Linux-specific tools
    util-linux        # Linux system utilities
    procps           # Process management tools
    iproute2         # Network configuration tools
    
    # Linux desktop tools (when running GUI)
    # xorg.xwininfo   # X11 utilities
    # xclip           # Clipboard management
    # firefox         # Browser (often preferred on Linux)
    
    # Linux development tools
    # gcc             # Already in shared, but might need specific version
    # gdb             # GNU debugger
    
    # Add other Linux-only packages here
  ];
}