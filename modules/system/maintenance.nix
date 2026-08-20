# modules/system/maintenance.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.maintenance = { config, pkgs, ... }: {
    
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
      flake = "github:hkn-alp/.nixos";
      dates = "daily";
      allowReboot = false;
    };
  };
}
