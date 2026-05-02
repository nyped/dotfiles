{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    kernelPackages =
      let
        rpiKernel = pkgs.callPackage "${inputs.nixos-hardware}/raspberry-pi/common/kernel.nix" {
          rpiVersion = 4;
          argsOverride = {
            src = pkgs.fetchFromGitHub {
              owner = "raspberrypi";
              repo = "linux";
              rev = "3d3dd5921d317d84208d1efe45d76abcda82eb98";
              hash = "sha256-TVNm1p8S47oqiTlr4H6g5GV+iKpOfi3jlWUrQHFESCI=";
            };
            version = "6.18.26";
            modDirVersion = "6.18.26";
          };
        };
      in
      pkgs.linuxPackagesFor rpiKernel;
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
      generic-extlinux-compatible.enable = true;
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
          pkgs.runCommand "tc358743-audio.dtbo"
            {
              nativeBuildInputs = [ pkgs.dtc ];
            }
            ''
              dtc -I dtb -O dts \
                ${pkgs.linuxKernel.packages.linux_rpi4.kernel}/dtbs/overlays/tc358743-audio.dtbo \
                | sed 's/compatible = "brcm,bcm2835"/compatible = "brcm,bcm2711"/' \
                | dtc -I dts -O dtb -@ -o $out
            '';
      }
    ];
  };

  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    tc358743.enable = true;
    dwc2 = {
      enable = true;
      dr_mode = "peripheral";
    };
  };

  hardware.enableRedistributableFirmware = true;
  nixpkgs.hostPlatform.system = "aarch64-linux";

  # Gadgets before docker
  systemd.services.kvm_gadgets = {
    description = "kvm gadgets register";
    script = builtins.readFile ./gadgets.sh;
    requiredBy = [ "docker.service" ];
  };
}
