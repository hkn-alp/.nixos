# modules/hosts/Cyron/disko-config.nix
{ ... }: {
  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # --- 1. EFI System Partition (ESP) ---
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

          # --- 2. LUKS Encrypted Root ---
          luks = {
            priority = 2;
            name = "cryptroot";
            # Fills the disk up to the last 8GB reserved for swap
            end = "-8G";
            content = {
              type = "luks";
              name = "cryptroot";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };

          # --- 3. Swap Partition (8GB) ---
          swap = {
            priority = 3;
            name = "swap";
            start = "-8G";
            end = "100%";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true; # Enables hibernation support to swap
            };
          };
        };
      };
    };
  };
}
