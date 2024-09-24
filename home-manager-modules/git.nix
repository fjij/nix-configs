{
  config,
  pkgs,
  lib,
  ...
}: let
  cfgName = "git";
  cfg = config.fjij.${cfgName};
in {
  options.fjij.${cfgName}.enable = lib.mkEnableOption cfgName;

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      git-lfs
    ];

    programs.git = {
      enable = true;
      userName = "fjij";
      userEmail = "30779570+fjij@users.noreply.github.com";
      aliases.sla = ''
        log --graph --all \
          --pretty=format:'%C(yellow)%h%C(reset) %an [%C(green)%ar%C(reset)] %s'
      '';
      ignores = [".vim/" ".envrc" ".env" ".DS_Store"];
      extraConfig = {
        core.editor = "nvim";
        core.excludesfile = "~/.gitignore";
        diff.colorMoved = "default";
        diff.tool = "vimdiff";
        merge.tool = "vimdiff";
        merge.conflictstyle = "diff3";
        difftool.vimdiff.cmd = "nvim -d $LOCAL $REMOTE";
        pager.branch = false;
        init.defaultBranch = "main";
        "add.interactive".useBuiltin = false;
        filter.lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
        url."ssh://git@github.com/".insteadOf = "https://github.com/";
      };
    };
  };
}
