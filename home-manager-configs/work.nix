{
  imports = [ ../home-manager-modules ];
  home = {
    username = "wharris";
    homeDirectory = "/home/wharris";
  };
  nixpkgs.config.allowUnfree = true;
  fjij.tools.enable = true;
  fjij.work-tools.enable = true;
  fjij.base.enable = true;
  fjij.nixvim.enable = true;
}
