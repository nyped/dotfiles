let
  patchDdcciDriver =
    final: prev: {
      ddcci-driver = prev.ddcci-driver.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./ddcci-driver-strscpy.patch
        ];
      });
    };
in
self: super: {
  linuxPackages = super.linuxPackages.extend patchDdcciDriver;
  linuxPackages_latest = super.linuxPackages_latest.extend patchDdcciDriver;
}