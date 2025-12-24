{
  pkgs,
  ...
}:
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  xdg.portal.xdgOpenUsePortal = true;

  services.gammastep = {
    enable = true;
    longitude = 48.8;
    latitude = 2.3;
    settings = {
      general = {
        fade = 1;
      };
    };
    temperature = {
      night = 4500;
      day = 6500;
    };
  };

  # Misc programs
  programs.swaylock.enable = true;
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  programs.waybar.systemd.target = "graphical-session.target";
  programs.fuzzel.enable = true;
  programs.firefox.enable = true;
}
