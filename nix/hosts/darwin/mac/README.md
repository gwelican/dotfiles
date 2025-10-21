# Mac Host Configuration

This directory can contain an optional `default.nix` file for host-specific overrides.

## Default Configuration (without override file):
The mac host automatically gets:
- **hostname**: "mac"
- **primary user**: "pvarsanyi" 
- **home directory**: "/Users/pvarsanyi"
- **Common packages**: All packages from `modules/darwin/packages.nix`
- **Common homebrew apps**: Standard productivity apps (bettertouchtool, raycast, etc.)
- **Common macOS defaults**: Standard dock settings, finder preferences, etc.

## To Add Host-Specific Overrides:

Create a `default.nix` file in this directory:

```nix
# Mac host-specific overrides (optional)
{ config, pkgs, ... }: let
  username = config.system.primaryUser;
in {
  # Add work-specific homebrew apps
  homebrew.casks = [
    "slack" 
    "microsoft-teams"
    "work-specific-app"
  ];
  
  # Add work-specific system packages
  environment.systemPackages = with pkgs; [
    # work tools here
  ];
  
  # Host-specific dock apps
  system.defaults.dock.persistent-apps = [
    "/Applications/Brave Browser.app"
    "/Applications/Slack.app"
    "/Applications/Microsoft Teams.app"
  ];
  
  # Override system defaults
  system.defaults = {
    dock.tilesize = 32; # smaller dock for work
    dock.autohide = true; # more screen space
  };
}
```

See `default.nix.example` for a complete template.

