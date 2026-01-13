# Common homebrew configuration for Darwin hosts
# Host-specific apps should be added in host override files
{...}: {

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    # Common homebrew brews (CLI tools)
    brews = [
      "mas"
      "kopia"
      "mole"
      # "block-goose-cli"
      # "graphite"
    ];

    # Common homebrew taps
    taps = [
      "homebrew/cask"
      "homebrew/core"
      "homebrew/bundle"
    ];

    # Common homebrew casks (GUI applications)
    casks = [
      # Essential productivity tools
      "bettertouchtool"
      "hammerspoon"
      "raycast"
      "block-goose"
      
      # Development tools
      "ghostty"
      "cursor"
      "visual-studio-code"
      
      # Communication
      "discord"
      
      # Browsers
      "brave-browser"
      "floorp"
      
      # Media
      "spotify"
      "vlc"
      
      # Utilities
      "rustdesk"
      "appcleaner"
      "wezterm"
      "obsidian"
      "1password"
      "linearmouse"
      "1password-cli"
      "loopback"
      "soundsource"
      "kopiaui"
      
      # Commonly used apps you might want to enable:
      # "adobe-creative-cloud"
      # "steam"
      # "audio-hijack"
      # "farrago"
      # "alacritty"
      # "audacity"
      # "bambu-studio"
      # "displaylink"
      # "element"
      # "firefox"
      # "iina"
      # "istat-menus"
      # "jordanbaird-ice"
      # "lm-studio"
      # "logitech-options"
      # "marta"
      # "notion"
      # "obs"
      # "orbstack"
      # "signal"
      # "viscosity"
    ];

    # Common Mac App Store applications
    masApps = {
      "Telegram" = 747648890;
      "Amphetamine" = 937984704;
      # "HiddenBar" = 1452453066;
      "Home Assistant Companion" = 1099568401;
      "Windows App" = 1295203466;
      
      # Additional apps you might want:
      # "Bitwarden" = 1352778147;
      # "DaVinci Resolve" = 571213070;
      # "Fantastical" = 975937182;
      # "Final Cut Pro" = 424389933;
      # "The Unarchiver" = 425424353;
      # "UTM" = 1538878817;
    };
  };
}
