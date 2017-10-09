{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.desktop;
in

{

  ###### interface

  options = {

    custom.desktop = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable basic desktop config with dwm.
        '';
      };

      laptop = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to activate services for battery, network, backlight.
        '';
      };

      printing = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to activate printing service.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    custom = {
      boot.isEFI = true;

      pass.enable = true;

      xserver = {
        enable = true;
        laptop = cfg.laptop;
      };
    };

    environment.systemPackages = with pkgs; [
      exfat
      ntfs3g
    ];

    services.printing.enable = cfg.printing;

  };

}
