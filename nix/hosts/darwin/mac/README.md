# Mac Host Configuration

This directory can contain an optional `default.nix` file for host-specific overrides.

If no `default.nix` file exists, the mac host will use only the common Darwin configuration with:

- hostname: "mac"
- primary user: "workusername"
- home directory: "/Users/workusername"

## To add overrides

Create a `default.nix` file in this directory with your host-specific configuration:

```nix
# Mac host-specific overrides (optional)
{ config, pkgs, ... }: {
  # Add mac-specific homebrew apps
  homebrew.casks = [
    "work-specific-app"
  ];
  
  # Add mac-specific system packages
  environment.systemPackages = with pkgs; [
    # work tools here
  ];
  
  # Override system defaults if needed
  system.defaults.dock.tilesize = 32; # smaller dock for work
}
```

See `default.nix.example` for a template.

