{ ... }: {
  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            priority = 2;
            name = "cryptroot";
            end = "-8G";
            content = {
              type = "luks";
              name = "cryptroot";
              settings = { allowDiscards = true; };
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = { mountpoint = "/"; mountOptions = [ "compress=zstd" "noatime" "discard=async" ]; };
                  "/nix"  = { mountpoint = "/nix"; mountOptions = [ "compress=zstd" "noatime" "discard=async" ]; };
                  "/home" = { mountpoint = "/home"; mountOptions = [ "compress=zstd" "noatime" "discard=async" ]; };
                  "/cache" = { mountpoint = "/home/hakanalp/.cache"; mountOptions = [ "compress=zstd" "noatime" "discard=async" ]; };
                  "/steam" = { mountpoint = "/home/hakanalp/.local/share/Steam"; mountOptions = [ "compress=zstd" "noatime" "discard=async" ]; };
                  "/containers" = { mountpoint = "/home/hakanalp/.local/share/containers"; mountOptions = [ "compress=zstd" "noatime" "discard=async" ]; };
                };
              };
            };
          };
          swap = {
            priority = 3;
            name = "swap";
            size = "100%";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/hakanalp/.cache 0700 hakanalp users - -"
    "d /home/hakanalp/.local/share/Steam 0700 hakanalp users - -"
    "d /home/hakanalp/.local/share/containers 0700 hakanalp users - -"
  ];
}
