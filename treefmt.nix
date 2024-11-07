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
  programs.fish_indent.enable = true;

  programs.mdformat.enable = true;
  # Otherwise, it will cause all numbers to be 1
  # https://github.com/executablebooks/mdformat/blob/8c573e4913ebb10a0bd30ae95b3620bd846856d7/README.md?plain=1#L109
  settings.formatter.mdformat.options = [ "--number" ];

  programs.mdsh.enable = true;
}
