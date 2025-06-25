{ inputs, outputs, config, lib, hostname, system, username, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  users.users.${username}.home = "/Users/${username}";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
    channel.enable = false;
  };
  system.stateVersion = 5;

  system.primaryUser = "${username}";

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${system}";
  };

  environment.systemPackages = with pkgs; [
    nixpkgs-unstable.legacyPackages.${pkgs.system}.mkalias

    p4v
    karabiner-elements
    vscode
    discord
    wezterm
    spotify
    obsidian
    # unstablePkgs.ghostty
    # unstablePkgs.openscad
    mas

    comma
    nix
  ];

  fonts.packages = with pkgs;[
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

  # pins to stable as unstable updates very often
  nix.registry = {
    n.to = {
      type = "path";
      path = inputs.nixpkgs;
    };
    u.to = {
      type = "path";
      path = inputs.nixpkgs-unstable;
    };
  };

  programs.nix-index.enable = true;

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   promptInit = builtins.readFile ./../../data/mac-dot-zshrc;
  # };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "none"; # change to zap
      # autoUpdate = true;
      # upgrade = true;
    };
    # global.autoUpdate = true;

    # brews = [
    #   "graphite"
    # ];
    # taps = [
    #   "withgraphite/tap"
    # ];
    casks = [
      "hammerspoon"
      "ghostty"
      "rustdesk"
      "appcleaner"
      # "screenflow"
      # "cleanshot"
      # "adobe-creative-cloud"
      # #"nikitabobko/tap/aerospace"
      # "alacritty"
      # "alcove"
      # "audacity"
      # #"balenaetcher"
      # "bambu-studio"
      # "bentobox"
      # #"clop"
      # "discord"
      # "displaylink"
      # #"docker"
      # "element"
      # "elgato-camera-hub"
      # "elgato-control-center"
      # "elgato-stream-deck"
      # "firefox"
      # "flameshot"
      # "font-fira-code"
      # "font-fira-code-nerd-font"
      # "font-fira-mono-for-powerline"
      # "font-hack-nerd-font"
      # "font-jetbrains-mono-nerd-font"
      # "font-meslo-lg-nerd-font"
      # "ghostty"
      # "google-chrome"
      # "iina"
      # "istat-menus"
      # "iterm2"
      # "jordanbaird-ice"
      # "lm-studio"
      # "logitech-options"
      # "macwhisper"
      # "marta"
      # "mqtt-explorer"
      # "music-decoy" # github/FuzzyIdeas/MusicDecoy
      # "nextcloud"
      # "notion"
      # "obs"
      # "obsidian"
      # "ollama"
      # "omnidisksweeper"
      # "orbstack"
      # "openscad"
      # "openttd"
      # "plexamp"
      # "popclip"
      # "prusaslicer"
      # "raycast"
      # "signal"
      # "shortcat"
      # "slack"
      # "spotify"
      # "steam"
      # "tailscale"
      # #"wireshark"
      # "viscosity"
      # "visual-studio-code"
      # "vlc"
      # # "lm-studio"
      #
      # # # rogue amoeba
      # "audio-hijack"
      # "farrago"
      # "loopback"
      # "soundsource"
    ];
    masApps = {
      "Telegram" = 747648890;
      "Amphetamine" = 937984704;
      "HiddenBar" = 1452453066;
      "Messenger" = 1480068668;
      "Home Assistant Companion" = 1099568401;
      "Microsoft Remote Desktop" = 1295203466;

      # "AutoMounter" = 1160435653;
      # "Bitwarden" = 1352778147;
      # "Creator's Best Friend" = 1524172135;
      # "DaVinci Resolve" = 571213070;
      # "Disk Speed Test" = 425264550;
      # "Fantastical" = 975937182;
      # "Ivory for Mastodon by Tapbots" = 6444602274;
      # "Perplexity" = 6714467650;
      # "Resize Master" = 102530679;
      # "rCmd" = 1596283165;
      # "Snippety" = 1530751461;
      # #"Tailscale" = 1475387142;
      # "The Unarchiver" = 425424353;
      # "Todoist" = 585829637;
      # "UTM" = 1538878817;
      # "Wireguard" = 1451685025;

      # "Final Cut Pro" = 424389933;

      # these apps only available via uk apple id
      #"Logic Pro" = 634148309;
      #"MainStage" = 634159523;
      #"Garageband" = 682658836;
      #"ShutterCount" = 720123827;
      #"Teleprompter" = 1533078079;

      # "Keynote" = 409183694;
      # "Numbers" = 409203825;
      # "Pages" = 409201541;
    };
  };

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = false;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS configuration
  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowScrollBars = "Always";
    NSGlobalDomain.NSUseAnimatedFocusRing = false;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain.InitialKeyRepeat = 25;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    LaunchServices.LSQuarantine = false; # disables "Are you sure?" for new apps
    loginwindow.GuestEnabled = false;
    finder.FXPreferredViewStyle = "Nlsv";
    dock.autohide = false;
    dock.orientation = "bottom";
    dock.show-recents = false;
    dock.show-process-indicators = true;
    dock.tilesize = 48;
    dock.minimize-to-application = true;
    dock.mineffect = "scale";
    dock.persistent-apps = [
      "${pkgs.obsidian}/Applications/Obsidian.app"
      "${pkgs.wezterm}/Applications/Wezterm.app"
      "${pkgs.spotify}/Applications/Spotify.app"
      "/Applications/Telegram.app"
      "/Applications/Slack.app"
      "/Applications/WezTerm.app"
      "/Applications/Discord.app"
      "/Applications/Messenger.app"
    ];
  };

  system.defaults.CustomUserPreferences = {
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
        DisableAllAnimations = true;
        NewWindowTarget = "PfDe";
        NewWindowTargetPath = "file://$\{HOME\}/Desktop/";
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowStatusBar = true;
        ShowPathbar = true;
        WarnOnEmptyTrash = false;
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      programs.direnv.enable = true;
      programs.zsh.enable = true;

      # system.activationScripts.applications.text = let
      #       env = pkgs.buildEnv {
      #         name = "system-applications";
      #         paths = config.environment.systemPackages;
      #         pathsToLink = "/Applications";
      #       };
      #     in
      #       pkgs.lib.mkForce ''
      #     # Set up applications.
      #     echo "setting up ${env}/Applications..." >&2
      #     rm -rf /Applications/Nix\ Apps
      #     mkdir -p /Applications/Nix\ Apps
      #     find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      #     while read -r src; do
      #       app_name=$(basename "$src")
      #         echo "copying $src" >&2
      #         ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      #         done
      #       '';


      NSGlobalDomain.AppleICUForce24HourTime = true;
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
      "com.apple.ActivityMonitor" = {
        OpenMainWindow = true;
        IconType = 5;
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };
      # "com.apple.Safari" = {
      #   # Privacy: don’t send search queries to Apple
      #   UniversalSearchEnabled = false;
      #   SuppressSearchSuggestions = true;
      # };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;

      # # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;

      # # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
  };
}
