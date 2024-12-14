if [ "$EUID" -eq 0 ];then
    source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
fpath=(/nix/var/nix/profiles/per-user/root/profile/share/zsh/site-functions/ $fpath)