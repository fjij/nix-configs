{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    _1password
  ];
  xdg.configFile = {
    alacritty = {
      source = ../../dotfiles/alacritty;
      recursive = true;
    };
    yabai = {
      source = ../../dotfiles/yabai;
      recursive = true;
    };
  };
}
