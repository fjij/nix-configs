{
  fjij,
  pkgs,
  ...
}: {
  imports = [
    fjij.home-manager.nixosModule
    (fjij.home-manager.mkHome {
      user = "willh";
      profile = fjij.home-manager.profiles.terminal;
    })
  ];

  users.users.willh = {
    isNormalUser = true;
    description = "Will Harris";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuZghgOTkdblxNA+cg8JQnQumgyxGiOoTouB7vT5XIW"
    ];
    # packages = with pkgs; [];
    shell = pkgs.fish;
    home = "/home/willh";
  };

  # Need to enable this here to allow it as a shell
  programs.fish.enable = true;
}
