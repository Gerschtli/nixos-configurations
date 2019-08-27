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

      laptop = mkEnableOption "services and config for battery, network, backlight";

    };

  };


  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    {

      boot.tmpOnTmpfs = true;

      custom = {
        misc.dev.enable = true;

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
        enableFontDir = true;
        enableGhostscriptFonts = true;
        fonts = with pkgs; [
          dejavu_fonts
          fira-code
          fira-mono
          nerdfonts
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

        xserver = {
          enable = true;

          desktopManager.xterm.enable = false;

          displayManager = {
            job.logToFile = mkForce false;

            # FIXME: enable lightdm after https://github.com/NixOS/nixpkgs/issues/26687 got fixed
            lightdm = {
              enable = false;
            };

            slim = {
              enable = true;
              defaultUser = "tobias";
            };
          };
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
        networking.networkmanager.enable = true;

        programs.light.enable = true;

        services = {
          logind.extraConfig = ''
            HandlePowerKey=ignore
          '';

          upower.enable = true;

          xserver.libinput = {
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
