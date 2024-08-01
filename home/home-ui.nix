{
  config,
  pkgs,
  ...
}: {
  # Dotfiles for UI-based programs specifically
  xdg.configFile = {
    alacritty = {
      source = ./alacritty;
      recursive = true;
    };
    yabai = {
      source = ./yabai;
      recursive = true;
    };
  };
}
