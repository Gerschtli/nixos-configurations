{ config, pkgs, ... }:

{
  imports = [ (import ./modules "xenon") ];

  custom = {
    base.server.enable = true;

    services.storage = {
      enable = true;
      mountDevice = "/dev/disk/by-uuid/e3cda2ab-9b36-4d60-9a9c-dfba6f00ab32";
      interval = "Wed *-*-* 04:00:00";
      expiresAfter = 90;
      server = [
        {
          name = "krypton";
          ip = "195.201.88.53";
        }
      ];
    };

    system.boot.mode = "raspberry";
  };

  environment.systemPackages = with pkgs; [
    exfat
    ntfs3g
  ];

  # hardware.bluetooth.enable = true;

  # Need to run: wpa_passphrase ESSID PSK > /etc/wpa_supplicant.conf
  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
  };

  # needed because wpa_supplicant fails on startup
  # see https://github.com/NixOS/nixpkgs/issues/82462
  systemd.services.wpa_supplicant.serviceConfig = {
    Restart = "always";
    RestartSec = 5;
  };
}
