# modules/system/power.nix
{ config, pkgs, ... }:

{
  # === 1. POWER MANAGEMENT ===
  
  # --- UPower ---
  # Allows reading accurate battery percentages and charging states.
  services.upower.enable = true;
  
  # --- Power Profiles Daemon ---
  # Allows switching between 'power-saver', 'balanced', and 'performance' modes.
  services.power-profiles-daemon.enable = true;
}
