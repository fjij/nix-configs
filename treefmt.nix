{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  programs.stylua = {
    enable = true;
    settings = {
      indent_type = "Spaces";
      indent_width = 2;
    };
  };
  programs.just.enable = true;
}
