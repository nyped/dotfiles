export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
xbindkeys
picom --config ~/dotfiles/picom.conf -b
exec i3
