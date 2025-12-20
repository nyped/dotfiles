self: super: {
  niri = super.niri.overrideAttrs (old: {
    doCheck = false;
    patches = old.patches ++ [
      ./niri-enable-three-finger.patch
    ];
  });
}
