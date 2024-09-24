# WSL-specific config

fish_add_path /mnt/c/Windows/System32/WindowsPowerShell/v1.0/
set WINUSER (powershell.exe '$env:UserName' | tr -d '\r\n')
set WINHOME /mnt/c/Users/$WINUSER

if test -e $WINHOME/.cargo
    fish_add_path $WINHOME/.cargo/bin
    fish_add_path /mnt/c/Program Files/Neovim/bin
end
