{
  profile,
  lib,
  ...
}:
{
  services.borgbackup.jobs =
    let
      common-excludes = [
        "*/*.7z"
        "*/*.a"
        "*/*.bin"
        "*/*.dat"
        "*/*.gz"
        "*/*.iso"
        "*/*.log"
        "*/*.mkv"
        "*/*.mp3"
        "*/*.mp4"
        "*/*.nosync"
        "*/*.o"
        "*/*.so"
        "*/*.tmp"
        "*/*.whl"
        "*/*.xz"
        "*/*.zip"
        "*/.*"
        "*/Cache"
        "*/VirtualBox VMs"
        "*/__pycache__"
        "*/_build"
        "*/blobs"
        "*/build"
        "*/cache"
        "*/cache2"
        "*/data"
        "*/models"
        "*/node_modules"
        "*/output"
        "*/venv"
      ];
      basicBorgJob = target: {
        environment.BORG_RSH = "ssh -i /home/${profile.user}/.ssh/id_ed25519";
        extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
        extraCompactArgs = "--threshold 0";
        repo = "${profile.backupHost}/./${target}";
        startAt = "daily";
        user = profile.user;
        encryption.mode = "repokey-blake2";
        encryption.passCommand = "cat /home/${profile.user}/.backup_pass.txt";
        prune.keep = {
          daily = 7;
          weekly = 4;
          monthly = 1;
        };
      };
    in
    {
      home = basicBorgJob profile.backupDir // {
        paths = "/home/${profile.user}";
        exclude = common-excludes;
      };
    }
    // lib.attrsets.optionalAttrs (builtins.length profile.backupExtraPaths != 0) {
      extra = basicBorgJob profile.backupDir // {
        paths = profile.backupExtraPaths;
        user = "root";
      };
    };
}
