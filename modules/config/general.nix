{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.general;
in

{

  ###### interface

  options = {

    custom.general = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable basic config.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    boot.cleanTmpDir = true;

    custom.services.firewall.enable = true;

    environment.systemPackages = with pkgs; [
      bc
      file
      git
      htop
      keychain
      neovim
      tmux
      tree
      wget

      gzip
      unzip
      xz
      zip

      bind # dig
      netcat
      psmisc # killall
      whois
    ];

    i18n = {
      consoleKeyMap = "de";
      defaultLocale = "en_US.UTF-8";
    };

    networking.usePredictableInterfaceNames = false;

    programs.zsh.enable = true;

    system.stateVersion = "17.03";

    time.timeZone = "Europe/Berlin";

    users = {
      defaultUserShell = pkgs.zsh;

      users.tobias = {
        extraGroups = [ "wheel" ];
        isNormalUser = true;
      };
    };

  };

}