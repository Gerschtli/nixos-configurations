# NixOS configurations

This repository manages all my NixOS configuration files and the corresponding library of custom
modules.

## Nodes

* `argon`: personal laptop
* `helium`: personal desktop
* `krypton`: server
* `xenon`: raspberry pi

## Set up

You need to link any configuration file first:
```bash
$ git clone git@github.com:Gerschtli/nixos-configurations.git /etc/nixos
$ git clone git@github.com:Gerschtli/home-manager-configurations.git /etc/nixos/home-manager-configurations
$ nixos-generate-config
$ ln -sf configuration-<host>.nix configuration.nix
```
