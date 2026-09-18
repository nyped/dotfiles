self: super: {
  flashrom = super.flashrom.overrideAttrs (old: {
    doCheck = false;
  });
}
