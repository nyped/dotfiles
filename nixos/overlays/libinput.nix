self: super: {
  libinput = super.libinput.overrideAttrs (old: {
    patches = old.patches ++ [
      ./libinput-enable-3fg-drag-by-default.patch
    ];
  });
}
