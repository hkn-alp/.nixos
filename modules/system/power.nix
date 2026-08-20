# modules/system/power.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.power = { config, pkgs, ... }: {
    
    # === 1. POWER MANAGEMENT ===
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };

}
