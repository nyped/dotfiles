# My linux settings on 8,1 macbook pro

## trackpad

I use mtrack and xbindkeys on Xorg. [useful link](https://int3ractive.com/2018/09/make-the-best-of-MacBook-touchpad-on-Ubuntu.html).

## theme

- [Macterial](https://www.gnome-look.org/p/1248255/) with gnome-tweaks.
- [Frippery move clock](https://extensions.gnome.org/extension/2/move-clock/) extenstion to move the clock on the right.

## 5ghz wifi driver on 8,1

- install `broadcom-sta-dkms` in Debian and `broadcom-wl` in Arch.

## boot manager

- install `refind` from your package manager. A nice looking theme [here] (https://github.com/EvanPurkhiser/rEFInd-minimal)

## fan daemon

- install `macfanctld` from your package manager. In arch, you have to create a service that runs the daemon at each boot.

## gnome configs

- [useful link](https://gist.github.com/reavon/0bbe99150810baa5623e5f601aa93afc) to restore your configs.

## bluetooth

`_ service bluetooth start` to start daemon

