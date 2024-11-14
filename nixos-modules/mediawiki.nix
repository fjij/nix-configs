{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.fjij.mediawiki;
in
{
  # MediaWiki
  # https://nixos.wiki/wiki/MediaWiki
  options.fjij.mediawiki = {
    enable = lib.mkEnableOption "Mediawiki";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "HTTP port to host on (SSL is disabled)";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "${config.networking.hostName}:${toString cfg.port}";
      description = "Expected web server hostname";
    };

    wikiName = lib.mkOption {
      type = lib.types.str;
      default = "FjijWiki";
      description = "Name of the wiki";
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
      default = pkgs.writeText "password" "cardbotnine";
      description = "Password file for admin account";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    services.mediawiki = {
      enable = true;
      name = cfg.wikiName;

      # Apache config
      httpd.virtualHost = {
        inherit (cfg) hostName;
        # This is a fake email, but it needs an email to work
        adminAddr = "admin@localhost";
        listen = [
          {
            ip = "0.0.0.0";
            port = cfg.port;
            ssl = false;
          }
        ];
      };

      # Administrator account username is admin.
      # Set initial password to "cardbotnine" for the account admin.
      inherit (cfg) passwordFile;

      # Disable anonymous editing
      extraConfig = ''
        $wgGroupPermissions['*']['edit'] = false;
      '';

      # Enable visual editor
      extensions.VisualEditor = null;
    };
  };
}
