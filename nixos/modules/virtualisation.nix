{
  profile,
  pkgs,
  ...
}:
{
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    data-root = "/docker";
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ profile.user ];

  environment.systemPackages = [ pkgs.dnsmasq ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  programs.virt-manager.enable = true;
  hardware.graphics.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  users.users.${profile.user}.extraGroups = [
    "libvirtd"
    "docker"
  ];
}
