{
  config,
  pkgs,
  lib,
  ...
}: let
  cfgName = "alacritty";
  cfg = config.fjij."${cfgName}";
in {
  options.fjij."${cfgName}" = {
    enable = lib.mkEnableOption "${cfgName}";

    macApp = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to add the MacOS app to Applications.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.alacritty];
    programs.alacritty.enable = true;

    xdg.configFile.alacritty = {
      source = ../dotfiles/alacritty;
      recursive = true;
    };

    home.activation.patchAlacrittyMacosApp = lib.mkIf cfg.macApp (
      let
        appDir = "${config.home.homeDirectory}/Applications";
        localApp = "${appDir}/Alacritty.app";
        storeApp = "${pkgs.alacritty}/Applications/Alacritty.app";
        bin = "${pkgs.alacritty}/bin";
      in
        # Adapted from https://github.com/NixOS/nix/issues/7055#issuecomment-2127541001
        # We had to adjust the 'MacOS' symlink to be absolute.
        lib.hm.dag.entryAfter ["writeBoundry"] ''
          $DRY_RUN_CMD [ -f ${localApp} ] && rm -rf ${localApp}
          $DRY_RUN_CMD cp -r ${storeApp} ${appDir}
          $DRY_RUN_CMD rm ${localApp}/Contents/MacOS && ln -s ${bin} ${localApp}/Contents/MacOS
          $DRY_RUN_CMD chmod -R 755 ${localApp}
        ''
    );
  };
}
