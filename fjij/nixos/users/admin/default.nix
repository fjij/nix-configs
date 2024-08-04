{pkgs, ...}: {
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      # Personal key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuZghgOTkdblxNA+cg8JQnQumgyxGiOoTouB7vT5XIW"
      # nixos-admin
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYmBfCYUXfCwBbux6bI3MnR4KpHv3rXulRmGjNeQQzM"
    ];
    shell = pkgs.bash;
    home = "/home/admin";
  };

  # Make it so admin users don't need to enter password to sudo
  security.sudo.wheelNeedsPassword = false;
}
