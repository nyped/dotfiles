self: super: {
  linuxPackages_latest = super.linuxPackagesFor (
    super.linux_6_18.override {
      argsOverride = rec {
        src = super.fetchurl {
          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
          sha256 = "558c6bbab749492b34f99827fe807b0039a744693c21d3a7e03b3a48edaab96a";
        };
        version = "6.18.2";
        modDirVersion = "6.18.2";
      };
    }
  );
}
