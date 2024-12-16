if [ "$EUID" -eq 0 ];then
    source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
fpath=(/nix/var/nix/profiles/per-user/root/profile/share/zsh/site-functions/ $fpath)


# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
