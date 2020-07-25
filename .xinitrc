xrdb -merge ~/.Xresources
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
picom --config ~/dotfiles/picom.conf -b
xbindkeys
exec i3
