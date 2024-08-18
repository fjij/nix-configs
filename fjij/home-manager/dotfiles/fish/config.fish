if status --is-interactive
  fish_add_path ~/scripts
end
set -gx CLICOLOR 1
set -gx MANPAGER 'sh -c \'col -bx | bat -l man -p\''
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
set -gx fish_greeting
fish_config prompt choose arrow
fish_add_path ~/bin

# Homebrew
if test -e /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end
if test -e /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Editor
set -gx EDITOR $(which nvim)

# 1Password CLI
if type -q op; and test -e ~/.config/op/plugins.sh
    source ~/.config/op/plugins.sh
end

# Git
abbr g git status
abbr gl git log
abbr gd git diff
abbr gds git diff --staged
abbr ga git add
abbr gc git commit
abbr gr git restore
abbr grs git restore --staged
abbr gp git push
abbr gpu git push -u origin HEAD
abbr gpull git pull
abbr gb git branch
function git_branch_choose_interactive
    git for-each-ref --format='%(refname:short)' refs/heads/ | gum choose
end
function git_branch_delete_interactive
    echo git branch --delete (git_branch_choose_interactive)
end
abbr gbd -f git_branch_delete_interactive
function git_switch_interactive
    echo git switch (git_branch_choose_interactive)
end
abbr gs -f git_switch_interactive
abbr gsc git switch --create
abbr gco git checkout
abbr guncommit git reset HEAD~

# Misc abbreviations
abbr x exit
abbr cls clear
abbr uk ultrakill

# Github
abbr issues gh issue list -a @me
abbr pr gh pr
function current_issue
    git branch --show-current | grep -o -E '[0-9]+'
end
abbr ISSUE --position=anywhere -f current_issue

# Local config
if test -e ~/local_config.fish
    source ~/local_config.fish
end

# WSL config
if test -e /etc/wsl.conf
    source ~/.config/fish/wsl_config.fish
end

# Cargo
if test -e ~/.cargo/bin
    fish_add_path ~/.cargo/bin
end

# Zoxide
if type -q zoxide
    zoxide init fish | source
    abbr cd z
end
