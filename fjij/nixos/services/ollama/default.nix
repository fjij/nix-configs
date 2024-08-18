{pkgs-unstable, ...}: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    package = pkgs-unstable.ollama;
  };
}
