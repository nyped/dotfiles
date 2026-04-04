{
  ...
}:
{
  imports = [
    ./packages.nix
    ./dotfiles.nix
  ];

  home.sessionVariables = {
    OPENCODE_EXPERIMENTAL = "1";
  };

  programs.opencode.enable = true;

  home.stateVersion = "26.05";
}
