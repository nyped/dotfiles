{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
  ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9b6c2f0b-cbb7-4384-8806-f42807df48a6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F65D-E051";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/data2" = {
    device = "/dev/disk/by-uuid/acf33d6e-5d6a-40cd-b0d9-00ccb34da762";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 32 * 1024;
    }
  ];

  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    ARRAY /dev/md/raid level=raid1 num-devices=2 metadata=1.2 UUID=b8664b84:51837323:1ffed847:cca9d5db devices=/dev/nvme0n1p2,/dev/nvme1n1p2
    PROGRAM ${pkgs.coreutils}/bin/true
  '';

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.cpufreq.min = 100000;
  powerManagement.cpufreq.max = 3000000;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
