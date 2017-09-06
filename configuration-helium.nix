{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/general.nix
    ./modules/pass.nix

    ./services/cups.nix
    ./services/pulseaudio.nix

    ./modules/dev-hosts.nix
    ./modules/xserver.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.device = "/dev/sda2";
    systemd-boot.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];


#  imports = [
#    ./modules/interface.nix
#  ];
#
#  custom.desktop = {
#    enable = true;
#    isLaptop = true;
#    grubDevice = "/dev/sda2";
#    additionalPackages = [ pkgs.ntfs3g ];
#    dev = true;
#    cups = true;
#  };

  networking.hostName = "helium";
}
