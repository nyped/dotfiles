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
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "cryptd"
  ];
  boot.extraModulePackages = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [
    "amd_pstate=passive"
    "amdgpu.dcdebugmask=0x10"
    "resume=/dev/mapper/lvmroot-swap"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "nfs" ];

  # CPU
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.cpufreq.min = 420000;
  powerManagement.cpufreq.max = 1500000;

  hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
  hardware.bluetooth.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/NIX";

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/NIXSWAP"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
