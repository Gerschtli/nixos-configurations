{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.base.desktop;
in

{

  ###### interface

  options = {

    custom.base.desktop = {
      enable = mkEnableOption "basic desktop config";

      enableXserver = mkEnableOption "xserver config" // { default = true; };

      laptop = mkEnableOption "services and config for battery, network, backlight";
    };

  };


  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    {
      boot.tmpOnTmpfs = true;

      custom = {
        programs.virtualbox.enable = true;

        system.boot.mode = "efi";
      };

      environment.systemPackages = with pkgs; [
        exfat
        ntfs3g

        # for android mtp
        jmtpfs
        go-mtpfs
      ];

      fonts = {
        enableDefaultFonts = true;
        enableFontDir = true;
        enableGhostscriptFonts = true;

        fonts = with pkgs; [
          nur-gerschtli.nerdfonts-ubuntu-mono
          source-code-pro
          ubuntu_font_family
        ];
      };

      hardware.pulseaudio.enable = true;

      nixpkgs.config.allowUnfree = true;

      programs = {
        # TODO: move to home-manager-configuration
        browserpass.enable = true;

        ssh.askPassword = "";
      };

      services = {
        udev.packages = with pkgs; [ android-udev-rules ];

        xserver = mkIf cfg.enableXserver {
          enable = true;

          # FIXME: enable lightdm after https://github.com/NixOS/nixpkgs/issues/26687 got fixed
          displayManager.lightdm.enable = true;

          # FIXME: why is this line needed? ~/.xsession is executed anyway..
          windowManager.dwm.enable = true;
        };
      };

      sound.enable = true;

      systemd.mounts = [
        {
          where = "/tmp";
          what = "tmpfs";
          options = "mode=1777,strictatime,nosuid,nodev,size=8G";
        }
      ];

      xdg = {
        autostart.enable = true;
        icons.enable = true;
        menus.enable = true;
        mime.enable = true;
        sounds.enable = true;
      };
    }

    (mkIf cfg.laptop
      {
        hardware = {
          bluetooth.enable = true;

          # for bluetooth support
          pulseaudio.package = pkgs.pulseaudioFull;
        };

        networking.networkmanager.enable = true;

        programs.light.enable = true;

        services = {
          blueman.enable = true;

          logind.extraConfig = ''
            HandlePowerKey=ignore
          '';

          upower.enable = true;

          xserver.libinput = mkIf cfg.enableXserver {
            enable = true;
            accelProfile = "flat";
            additionalOptions = ''
              Option "TappingButtonMap" "lmr"
            '';
          };
        };

        users.users.tobias.extraGroups = [ "video" ];
      }
    )

  ]);

}
