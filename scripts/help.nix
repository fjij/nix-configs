{ pkgs, ... }:
{
  # https://ryantm.github.io/nixpkgs/builders/trivial-builders/#trivial-builder-writeShellApplication
  help = pkgs.writeShellApplication {
    name = "just-help";
    runtimeInputs = with pkgs; [ just ];
    text = ''
      just help
    '';
  };
}
