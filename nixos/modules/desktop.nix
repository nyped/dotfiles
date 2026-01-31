{
  pkgs,
  ...
}:
{
  # Sound
  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  security.rtkit.enable = true;

  # System fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  # Misc services
  services.libinput.enable = true;
  programs.niri.enable = true;
  services.blueman.enable = true;
  services.ddccontrol.enable = true;

  # dconf for theme management
  programs.dconf.enable = true;
  programs.dconf.profiles.user = {
    databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };

  # Portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
    ];
    xdgOpenUsePortal = true;
  };

  # Default apps
  xdg.mime.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };

  # Login
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;

  # Env vars
  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    LIBVA_DRIVER_NAME = "radeonsi";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
