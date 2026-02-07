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
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [
    "default_hugepagesz=1G"
    "hugepagesz=1G"
    "hugepages=24"
    "amd_pstate=passive"
    "ttm.pages_limit=29360128"
    "ttm.page_pool_size=29360128"
    "kvm.enable_virt_at_load=0"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "nfs" ];

  # CPU
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.cpufreq.min = 400000;
  powerManagement.cpufreq.max = 4000000;

  hardware.bluetooth.enable = false;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a7e64b55-0cf1-4cb0-892a-5c6d22f7c509";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CFA3-D7CC";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 64 * 1024;
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
