{
  pkgs,
  lib,
  profile,
  ...
}:
let
  match =
    v: l:
    builtins.elemAt (lib.lists.findFirst (
      x: ((v: p: if lib.attrsets.matchAttrs p v then v else null) v (builtins.elemAt x 0)) != null
    ) null l) 1;
in
{
  home.packages =
    with pkgs;
    [
      bash-language-server
      bat
      cargo
      cmake
      dmenu
      eza
      fastfetch
      file
      gcc
      glib
      gnumake
      gnupg
      gopls
      handlr
      imagemagick
      jq
      lua
      lua-language-server
      nil
      ninja
      nix-search-cli
      nixfmt
      nmap
      oscclip
      pandoc
      papirus-icon-theme
      pass
      pyright
      python312
      ruff
      rust-analyzer
      rustc
      rustfmt
      shellcheck
      stow
      tinymist
      tldr
      translate-shell
      tree-sitter
      typst
      typstyle
      uv
      wl-clipboard
    ]
    ++ (
      if profile.desktop then
        # Desktop only packages
        [
          adwaita-icon-theme
          bemenu
          brightnessctl
          chromium
          discord
          dunst
          gammastep
          kitty
          libnotify
          nautilus
          networkmanagerapplet
          pavucontrol
          playerctl
          pulseaudio
          remmina
          slurp
          spotify
          swaybg
          swayidle
          swaylock
          vlc
          wdisplays
          xournalpp
          xwayland-satellite
          zathura
        ]
      else
        # Server only packages
        [
        ]
    )
    ++ match { cpu = profile.cpu; } [
      [
        { cpu = "amd"; }
        [
          btop-rocm
          fw-ectool
        ]
      ]
      [
        { cpu = "intel"; }
        [
          btop
          intel-gpu-tools
        ]
      ]
      [
        { cpu = "broadcom"; }
        [
          alsa-utils
          btop
          v4l-utils
          raspberrypi-eeprom
        ]
      ]
    ];
}
