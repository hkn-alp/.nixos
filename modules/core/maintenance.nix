{ config, pkgs, ... }: {
  # === 1. DRIVE MEMORY SAVER (GARBAGE COLLECTION) ===
  nix.settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # === 2. NVMe WEAR REDUCTION (RAM-BASED /tmp) ===
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };
}
