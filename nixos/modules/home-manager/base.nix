{
  ...
}:
{
  imports = [
    ./packages.nix
    ./dotfiles.nix
  ];

  home.sessionVariables = {
  };

  programs.opencode.enable = true;

  home.stateVersion = "25.05";
}
