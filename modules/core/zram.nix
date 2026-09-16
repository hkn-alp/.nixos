{ config, ... }: {
  zramSwap = {
    enable = true;
    algorithm = "lz4"; # Faster compression latency than zstd for desktop usage
    memoryPercent = 50;
    priority = 100;    # Guarantees zram fills up completely before NVMe swap is touched
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;        # Aggressively pages cold anonymous memory into compressed zram
    "vm.vfs_cache_pressure" = 50; # Retains directory structure & inode cache in memory longer
    "vm.page-cluster" = 0;        # Reads single pages instead of clusters (ideal for zram)
  };
}
