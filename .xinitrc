export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
picom --config ~/dotfiles/picom.conf -b
exec i3
