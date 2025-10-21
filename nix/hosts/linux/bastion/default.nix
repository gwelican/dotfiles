{pkgs, ...}: let
  username = "gwelican";
  hostname = "bastion";
in {
  networking.hostName = hostname;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = ["wheel" "networkmanager"];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
