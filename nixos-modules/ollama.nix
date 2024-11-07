{
  config,
  lib,
  ...
}:
let
  cfg = config.fjij.ollama;
in
{
  options.fjij.ollama.enable = lib.mkEnableOption "Ollama";

  config = lib.mkIf cfg.enable {
    fjij.nvidia.enable = true;

    services.ollama = {
      enable = true;
      acceleration = "cuda";
      openFirewall = true;
      host = "0.0.0.0";
    };
  };
}
