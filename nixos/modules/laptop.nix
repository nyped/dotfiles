{
  pkgs,
  config,
  ...
}:
{
  # Hibernation
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "suspend";
  services.logind.settings.Login.HandlePowerKey = "suspend";
  services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=60m
    SuspendState=mem
  '';

  # WG port
  networking.firewall.allowedUDPPorts = [ 1194 ];
  networking.firewall.enable = true;

  # Fingerprint
  services.fprintd.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  services.fprintd.tod.enable = true;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.sudo.rules.auth.fprintd.order =
    config.security.pam.services.sudo.rules.auth.unix.order + 50;
}
