alias update_kk='sudo pacman -Syu && flatpak update && flatpak uninstall --unused && yay -Syu --aur'
alias git_prune='git gc --prune=now && git gc --aggressive --prune=now'
alias git_repack='git repack -a -d -f --depth=250 --window=250'
