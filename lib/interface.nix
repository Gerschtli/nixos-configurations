{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ./applications/auto-golden-river-jazztett.nix
    ./applications/golden-river-jazztett.nix
    ./boot.nix
    ./desktop.nix
    ./dev.nix
    ./general.nix
    ./server.nix
    ./services/httpd.nix
    ./services/mysql.nix
    ./services/teamspeak.nix
    ./xserver.nix
  ];
}