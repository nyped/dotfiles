{
  ...
}:
{
  services.gnome.gnome-remote-desktop.enable = true;

  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.displayManager.autoLogin.enable = false;
  services.getty.autologinUser = null;

  networking.firewall.allowedTCPPorts = [
    3389
    5900
  ];
}
