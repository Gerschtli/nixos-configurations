# !DEPRECATED! See [nix-config](https://github.com/Gerschtli/nix-config)

I am transitioning to a flakes-only setup within a mono-repo containing all configs.

# NixOS configurations

This repository manages all my NixOS configuration files and the corresponding library of custom
modules.

## Nodes

* `krypton`: server
* `neon`: personal laptop
* `xenon`: raspberry pi

## Set up

You need to link any configuration file first:
```bash
$ git clone git@github.com:Gerschtli/nixos-configurations.git /etc/nixos
$ git clone git@github.com:Gerschtli/home-manager-configurations.git /etc/nixos/home-manager-configurations
$ nixos-generate-config
$ ln -sf configuration-<host>.nix configuration.nix
```

## Build sd-card image for raspberry pi

See `./misc/sd-image.nix` for further instructions.

## Update firmware for raspberry pi

Firmware is only written on sd-card image creation. Therefore it is necessary to update the firmware manually
through copying these files to the firmware partition.

See `./misc/build-firmware.nix` for further instructions.
