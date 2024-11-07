{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt-rfc-style.enable = true;
}
