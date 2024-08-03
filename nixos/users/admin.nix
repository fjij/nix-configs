{pkgs, ...}: {
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.bash;
    home = "/home/admin";
  };

  # Make it so admin users don't need to enter password to sudo
  security.sudo.wheelNeedsPassword = false;
}
