{ config, ... }:
{
   system.defaults.dock = {
    persistent-apps = [
      "/Applications/Brave Browser.app"
      "/Applications/Telegram.app"
      "/Applications/Discord.app"
      # "/Applications/Slack.app"
      "/Applications/Obsidian.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Spotify.app"
      "/Applications/Plexamp.app"
      "/Applications/Ghostty.app"
    ];
  };
}
