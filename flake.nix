{
  description = "nyped conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      user_ = "lenny";
      mkConfiguration =
        {
          backupDir ? "backup",
          backupExtraPaths ? [ ],
          backupHost ? "ssh://borgwarehouse@bw.lan:3522",
          desktop ? true,
          host ? "nixos",
          server ? false,
          user ? user_,
        }@args:
        let
          profile = {
            backupDir = backupDir;
            backupExtraPaths = backupExtraPaths;
            backupHost = backupHost;
            desktop = desktop;
            host = host;
            server = server;
            user = user;
          };
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs profile;
          };
          modules = [
            ./nixos/machines/${args.host}/configuration.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        slate = mkConfiguration {
          host = "slate";
          desktop = true;
          server = false;
          backupDir = "ef0d7b56";
          backupExtraPaths = [
            "/home/${user_}/.ssh"
            "/home/${user_}/.gnupg"
          ];
        };
        halo = mkConfiguration {
          host = "halo";
          desktop = false;
          server = true;
          backupDir = "b7acfef1";
        };
        miami = mkConfiguration {
          host = "miami";
          desktop = false;
          server = true;
          backupDir = "432af1f0";
          backupExtraPaths = [ "/data" ];
        };
      };
    };
}
