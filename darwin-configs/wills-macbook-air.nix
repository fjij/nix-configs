{
  imports = [ ../darwin-modules ];
  services.tailscale.enable = true;
  fjij.darwin = {
    base.enable = true;
    homebrew.enable = true;
    will-user.enable = true;
  };
  nix.enable = false;
}
