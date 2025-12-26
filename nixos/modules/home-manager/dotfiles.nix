{
  config,
  ...
}:
let
  mkOut =
    target: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${target}";
in
{
  home.file = {
    ".config/bat/dark_bat.conf".source = mkOut "bat/.config/bat/dark_bat.conf";
    ".config/bat/light_bat.conf".source = mkOut "bat/.config/bat/light_bat.conf";

    ".config/dunst/dark_dunstrc".source = mkOut "dunst/.config/dunst/dark_dunstrc";
    ".config/dunst/light_dunstrc".source = mkOut "dunst/.config/dunst/light_dunstrc";

    ".config/fuzzel/fuzzel.ini".source = mkOut "fuzzel/.config/fuzzel/fuzzel.ini";

    ".config/kitty/kitty-dark-scheme.conf".source = mkOut "kitty/.config/kitty/kitty-dark-scheme.conf";
    ".config/kitty/kitty-light-scheme.conf".source =
      mkOut "kitty/.config/kitty/kitty-light-scheme.conf";
    ".config/kitty/kitty.conf".source = mkOut "kitty/.config/kitty/kitty.conf";

    ".config/niri/config.kdl".source = mkOut "niri/.config/niri/config.kdl";

    ".config/nvim/lua".source = mkOut "nvim/.config/nvim/lua";
    ".config/nvim/init.lua".source = mkOut "nvim/.config/nvim/init.lua";

    ".config/sway/config".source = mkOut "sway/.config/sway/config";
    ".config/sway/mark.sh".source = mkOut "sway/.config/sway/mark.sh";
    ".config/sway/menu.sh".source = mkOut "sway/.config/sway/menu.sh";

    ".config/swaylock/config".source = mkOut "swaylock/.config/swaylock/config";

    ".config/waybar/config".source = mkOut "waybar/.config/waybar/config";
    ".config/waybar/style.css".source = mkOut "waybar/.config/waybar/style.css";

    ".config/zathura/zathurarc".source = mkOut "zathura/.config/zathura/zathurarc";

    ".config/tmux/tmux.conf".source = mkOut "tmux/.config/tmux/tmux.conf";

    "bin/backlight".source = mkOut "scripts/bin/backlight";
    "bin/color".source = mkOut "scripts/bin/color";
    "bin/i6_vpn".source = mkOut "scripts/bin/i6_vpn";
    "bin/lyrics".source = mkOut "scripts/bin/lyrics";
    "bin/screenshot".source = mkOut "scripts/bin/screenshot";
    "bin/volume".source = mkOut "scripts/bin/volume";

    ".zshrc".source = mkOut "zsh/dot-zshrc";
    ".zsh".source = mkOut "zsh/dot-zsh";

    ".Xresources".source = mkOut "xsession/dot-Xresources";
  };
}
