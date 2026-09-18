{
  inputs,
  lib,
  modulesPath,
  ...
}:
let
  crossPkgs = import inputs.nixpkgs {
    localSystem = "x86_64-linux";
    crossSystem = "aarch64-linux";
  };
  rpiKernel = crossPkgs.callPackage "${inputs.nixos-hardware}/raspberry-pi/common/kernel.nix" {
    rpiVersion = 4;
    argsOverride = {
      src = crossPkgs.fetchFromGitHub {
        owner = "raspberrypi";
        repo = "linux";
        rev = "4bb240615790ea5bd939484f4595b6952ac94ef4";
        hash = "sha256-aI1Rqihe3nV3th2/gEKS4Y1A9AClT9l5688WROiVRrM=";
      };
      version = "6.18.52";
      modDirVersion = "6.18.52";
    };
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    kernelPackages = crossPkgs.linuxPackagesFor rpiKernel;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    kernelModules = [
      "libcomposite"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.useGenerationDeviceTree = false;
    };
    kernelParams = [
      "usb-storage.quirks=152d:0583:u"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 8 * 1024;
    }
  ];

  hardware.deviceTree = {
    enable = true;
    filter = lib.mkForce "bcm2711-rpi-4-b.dtb";
    overlays = [
      {
        name = "tc358743-audio";
        # The nixos-hardware tc358743 overlay sets the DTB root compatible to
        # "brcm,bcm2711", so patch the dtbo to match (it ships as "brcm,bcm2835"
        # which then fails the dtmerge compatibility check).
        dtboFile =
          crossPkgs.runCommand "tc358743-audio.dtbo"
            {
              nativeBuildInputs = [ crossPkgs.buildPackages.dtc ];
            }
            ''
              dtc -I dtb -O dts \
                ${rpiKernel}/dtbs/overlays/tc358743-audio.dtbo \
                | sed 's/compatible = "brcm,bcm2835"/compatible = "brcm,bcm2711"/' \
                | dtc -I dts -O dtb -@ -o $out
            '';
      }
    ];
  };

  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    tc358743.enable = true;
  };

  hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi4 = [
    { dwc2.dr_mode = "peripheral"; }
  ];

  hardware.enableRedistributableFirmware = true;
  nixpkgs.hostPlatform.system = "aarch64-linux";

  # Gadgets before docker
  systemd.services.kvm_gadgets = {
    description = "kvm gadgets register";
    script = builtins.readFile ./gadgets.sh;
    requiredBy = [ "docker.service" ];
  };
}
