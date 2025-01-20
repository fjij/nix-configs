{
  imports = [ ../home-manager-modules ];
  home = {
    username = "wharris";
    homeDirectory = "/Users/wharris";
  };
  nixpkgs.config.allowUnfree = true;
  fjij.mac-gui.enable = true;
  fjij.tools.enable = true;
  fjij.base.enable = true;
  fjij.nixvim.enable = true;
}
