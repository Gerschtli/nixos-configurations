{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.services.mysql;
in

{

  ###### interface

  options = {

    custom.services.mysql = {
      enable = mkEnableOption "mysql (MariaDB)";

      backups = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = ''
          List of databases to backup.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    # Need to run:
    # CREATE USER 'backup'@'localhost' IDENTIFIED BY 'password';
    # GRANT SELECT, LOCK TABLES ON *.* TO 'backup'@'localhost';
    custom.services.backup.services.mysql = {
      description = "Mysql";
      interval = "Tue *-*-* 04:10:00";
      expiresAfter = 28;

      script =
        let
          passwordFile = config.lib.custom.path.secrets + "/mysql-backup-password";
        in
          concatMapStringsSep
            "\n"
            (database: ''
              ${pkgs.mariadb}/bin/mysqldump -ubackup -p$(cat ${passwordFile}) ${database} | \
                ${pkgs.gzip}/bin/gzip -c > ${database}-$(date +%s).gz
            '')
            cfg.backups;
    };

    services.mysql = {
      # Set password with:
      # SET PASSWORD FOR root@localhost = PASSWORD('password');
      enable = true;
      package = pkgs.mariadb;
    };

  };

}
