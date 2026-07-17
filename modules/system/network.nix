# modules/system/network.nix
{ config, pkgs, ... }:

{
  # === 1. NETWORKING DAEMONS ===
  
  # --- NetworkManager ---
  # Standard network configuration.
  networking.networkmanager.enable = true;
  
  # --- Firewall ---
  networking.firewall.enable = true;
}
