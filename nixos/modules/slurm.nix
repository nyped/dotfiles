{
  profile,
  config,
  lib,
  ...
}:
{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."munge/key" = {
    sopsFile = ../../secrets/munge-key;
    format = "binary";
    owner = "munge";
  };

  services.munge = {
    enable = true;
    password = config.sops.secrets."munge/key".path;
  };

  networking.firewall.allowedTCPPorts =
    lib.optionals (config.services.slurm.server.enable || config.services.slurm.client.enable)
      [
        6817
        6818
      ];
  networking.firewall.allowedTCPPortRanges = lib.optionals config.services.slurm.client.enable [
    {
      from = 60001;
      to = 60300;
    }
  ];

  services.slurm = {
    clusterName = "home";
    controlMachine = "miami";

    server.enable = profile.host == "miami";
    client.enable = builtins.elem profile.host [
      "miami"
    ];
    enableStools = builtins.elem profile.host [ "slate" ];

    nodeName = [
      "miami CPUs=4 RealMemory=15700 State=UNKNOWN"
    ];

    partitionName = [
      "all Nodes=ALL Default=YES MaxTime=60:00 State=UP OverSubscribe=NO"
    ];

    extraConfig = ''
      ReturnToService=2

      SrunPortRange=60001-60300

      ProctrackType=proctrack/cgroup
      TaskPlugin=task/cgroup
    '';

    extraCgroupConfig = ''
      ConstrainCores=yes
      ConstrainDevices=yes
      ConstrainRAMSpace=yes
      ConstrainSwapSpace=yes
    '';
  };
}
