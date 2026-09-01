{ config, pkgs, ... }: {
  # === 1. DRIVE MEMORY SAVER (GARBAGE COLLECTION) ===
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
