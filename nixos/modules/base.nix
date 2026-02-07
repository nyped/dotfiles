{
  pkgs,
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

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
    persistent = true;
    randomizedDelaySec = "45min";
  };

  # Stuck in the past
  programs.nix-ld.enable = true;

  # User
  users.users.${profile.user} = {
    isNormalUser = true;
    extraGroups = [
      "audio"
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
  services.passSecretService.enable = true;

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
}
