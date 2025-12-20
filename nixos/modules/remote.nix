{
  pkgs,
  lib,
  ...
}:
{
  services.xrdp.enable = true;
  services.xrdp.audio.enable = true;
  services.xrdp.defaultWindowManager = "xfce4-session";
  services.xrdp.openFirewall = true;
  services.getty.autologinUser = null;
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.autoLogin.enable = false;
  services.displayManager.defaultSession = "xfce";

  # Pulseaudio
  services.pipewire.enable = lib.mkForce false;
  services.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-module-xrdp ];
  };
}
