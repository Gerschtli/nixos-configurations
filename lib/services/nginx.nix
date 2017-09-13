{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.services.nginx;
in

{

  ###### interface

  options = {

    custom.services.nginx = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to install and configure nginx.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
    };

  };

}
