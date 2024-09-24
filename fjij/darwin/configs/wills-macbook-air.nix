{
  imports = [../modules];
  services.tailscale.enable = true;
  fjij.darwin = {
    base.enable = true;
    homebrew.enable = true;
    will-user.enable = true;
  };
}
