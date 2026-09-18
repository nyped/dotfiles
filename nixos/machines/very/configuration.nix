{
  inputs,
  profile,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/server.nix
    ../../modules/virtualisation.nix
  ];

  # Custom packages
  nixpkgs.overlays = [
    (import ../../overlays/flashrom.nix)
  ];

  # Home
  home-manager = {
    extraSpecialArgs = { inherit inputs profile; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      ${profile.user} = {
        imports = [
          ./../../modules/home-manager/base.nix
        ];
      };
    };
  };

  nix.settings = {
    substituters = [ "https://nyped-rpi4.cachix.org" ];
    trusted-public-keys = [ "nyped-rpi4.cachix.org-1:1iM0MnkSvq3CZXfFkc/7MpawYyfPQWvDBj4JKV1KOZ0=" ];
  };

  # Machine
  networking.hostName = "very";

  system.stateVersion = "23.11";
}
