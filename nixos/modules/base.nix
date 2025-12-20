{
  pkgs,
  lib,
  profile,
  ...
}:
{
  # Nix config
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Stuck in the past
  programs.nix-ld.enable = true;

  # User
  users.users.${profile.user} = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "docker"
      "i2c"
      "render"
      "video"
      "wheel"
    ];
  };

  # Networking
  networking.networkmanager.enable = true;

  # Time
  time.timeZone = "Europe/Paris";

  # Local authority
  security.pki.certificates = [
    (builtins.readFile ../cert/lan.crt)
  ];

  # Shell
  programs.zsh.enable = true;
  programs.command-not-found.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.vteIntegration = true;
  users.defaultUserShell = pkgs.zsh;

  # Services
  services.fwupd.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;
  programs.ssh.setXAuthLocation = true;

  # Secrets
  programs.gnupg.agent.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    borgbackup
    busybox
    curl
    htop
    git
    neovim
    ripgrep
    tree
    wireguard-tools
  ];

  # Big no
  services.gnome.gnome-keyring.enable = lib.mkForce false;
}
