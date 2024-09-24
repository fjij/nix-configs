{
  config,
  pkgs,
  lib,
  ...
}: let
  cfgName = "tmux";
  cfg = config.fjij.${cfgName};
in {
  options.fjij.${cfgName}.enable = lib.mkEnableOption cfgName;

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tmux
    ];

    programs.tmux = {
      enable = true;
      sensibleOnTop = false;
      terminal = "tmux-256color";
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;
      prefix = "C-g";
      shell = "$SHELL";
      extraConfig = ''
        # General
        # -------

        # Colors
        set-option -sa terminal-features ',alacritty:RGB'

        # Tabs
        set -g renumber-windows on

        # Misc
        set -g display-time 4000
        set -g status-interval 5
        set -g status-keys emacs
        set -g focus-events on

        # SSH Agent Forwarding
        # https://werat.dev/blog/happy-ssh-agent-forwarding/
        # https://gist.github.com/bcomnes/e756624dc1d126ba2eb6

        set -g update-environment -r
        set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/ssh_auth_sock

        # Appearance
        # ----------

        # Status Bar
        set -g window-status-current-format "#[fg=colour1] #I.#W#F "
        set -g window-status-format "#[fg=default] #I.#W#F "
        set -g status-style bg=default
        set -g status-left "#[bg=default] #S "
        set -g status-left-length 20
        set -g status-right "#[bg=default] #(date +'%%-d %%b %%Y  %%l:%%M %%p') "
        set -g status-right-length 40
        set -g status-justify absolute-centre

        # Border
        set -g pane-border-style 'fg=colour8, bg=default'
        set -g pane-active-border-style 'fg=colour8, bg=default'

        # Mode style
        set -g mode-style "fg=default,bg=colour1"

        # REBINDS
        # -------

        # Reload conf
        bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

        # Window navigation
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # Window splitting
        bind-key - split-window -v -c '#{pane_current_path}'
        bind-key '\' split-window -h -c '#{pane_current_path}'

        # Tab creation
        bind-key c new-window -c '#{pane_current_path}'

        # Window resizing
        bind -n S-Left resize-pane -L 2
        bind -n S-Right resize-pane -R 2
        bind -n S-Down resize-pane -D 1
        bind -n S-Up resize-pane -U 1

        # Breakaway pane
        bind-key b break-pane -d

        # Copy mode
        bind-key g copy-mode
        setw -g mode-keys vi
        bind-key -Tcopy-mode-vi v send -X begin-selection
        bind-key -Tcopy-mode-vi V send -X select-line
        bind-key -Tcopy-mode-vi C-V send -X rectangle-toggle
        bind-key -Tcopy-mode-vi y send -X copy-selection
        bind-key -Tcopy-mode-vi Escape send -X stop-selection
        bind-key -Tcopy-mode-vi Escape send -X clear-selection
      '';
    };
  };
}
