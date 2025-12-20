{
  ...
}:
{
  imports = [
    ./packages.nix
  ];

  home.sessionVariables = {
  };

  programs.opencode = {
    enable = true;
    settings = {
      theme = "system";
      autoupdate = true;
    };
  };

  home.stateVersion = "25.05";
}
