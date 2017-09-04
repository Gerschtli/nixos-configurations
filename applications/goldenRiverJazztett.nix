{ pkgs, config, ... }:

let

  fetchBitBucket = import ../util/fetchBitBucket.nix pkgs;

  goldenRiverJazztett = pkgs.stdenv.mkDerivation rec {
    name = "golden-river-jazztett-${version}";
    version = "2017-09-03";

    src = fetchBitBucket {
      url = "git@bitbucket.org:tobiashapp/golden-river-jazztett.git";
      rev = "eac760aafff855f1bbb5430c54cec5b890df5d04";
      sha256 = "147v84r5p1hvdj9qx54q3p6xynf8hkic4lhh245rilvsmkawj28f";
    };

    phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

    installPhase = "cp -R . \$out";

    postFixup = ''
      find $out -maxdepth 1 -type f -exec rm {} \+
      find $out -type f -name '*.sass' -o -name '*.scss' -exec rm {} \+
    '';
  };

in

{
  imports = [
    ../services/httpd.nix
    ../services/mysql.nix
  ];

  services.httpd = {
    enablePHP = true;
    virtualHosts = [
      {
        hostName = "goldenriverjazztett.de";
        serverAliases = [ "www.goldenriverjazztett.de" ];
        documentRoot = "${goldenRiverJazztett}/public";
        extraConfig = ''
          <Directory ${goldenRiverJazztett}/public>
            Options -Indexes
            DirectoryIndex index.php
            AllowOverride All
          </Directory>
        '';
      }
    ];
  };
}