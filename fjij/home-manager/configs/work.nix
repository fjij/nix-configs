{
  imports = [../modules];
  home = {
    username = "wharris";
    homeDirectory = "/home/wharris";
  };
  nixpkgs.config.allowUnfree = true;
  fjij.tools.enable = true;
  fjij.base.enable = true;
}
