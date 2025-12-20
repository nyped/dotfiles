{
  profile,
  ...
}:
{
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    data-root = "/docker";
  };

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ profile.user ];
}
