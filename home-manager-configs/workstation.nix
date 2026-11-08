# The terminal environment, for the dev workstation image (see images/workstation.nix)
{
  imports = [ ./terminal.nix ];
  home = {
    username = "willh";
    homeDirectory = "/home/willh";
  };
  nixpkgs.config.allowUnfree = true;
  # The image puts home.path on PATH itself, so activation only links files into the home
  # directory. The image's store is replaced on every update, so a profile would go stale.
  submoduleSupport.externalPackageInstall = true;
}
