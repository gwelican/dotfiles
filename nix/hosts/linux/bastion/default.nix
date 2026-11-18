{ pkgs, ... }:
let
  username = "gwelican";
  hostname = "bastion";
in
{
  networking.hostName = hostname;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # sda1 is a 1M bios-boot partition and /sys/firmware/efi is absent, so this box
  # boots x86-64 BIOS with GRUB on /dev/sda, not systemd-boot.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Installer layout: sda2 -> /boot, sda3 -> LVM ubuntu-vg/ubuntu-lv -> /
  fileSystems = {
    "/" = {
      device = "/dev/ubuntu-vg/ubuntu-lv";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/419551b4-c760-4f8d-a30a-3a28c867fc2d";
      fsType = "ext4";
    };
  };

  swapDevices = [ { device = "/swap.img"; } ];
}
