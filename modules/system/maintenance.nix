# modules/system/maintenance.nix
{ config, pkgs, ... }: {
  
  # === 1. DRIVE MEMORY SAVER (GARBAGE COLLECTION) ===
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # === 2. UNATTENDED AUTO-UPGRADES FROM GITHUB ===
  system.autoUpgrade = {
    enable = true;
    
    # Pull the configuration exclusively from your GitHub repository
    flake = "github:hkn-alp/.nixos";
    
    # Check for updates daily
    dates = "daily";
    
    # Apply updates smoothly in the background without forcing a reboot
    allowReboot = false;
  };
}
