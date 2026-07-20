# modules/system/network.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.network = { config, pkgs, ... }: {
    
    # === 1. NETWORKING DAEMONS ===
    
    # --- NetworkManager ---
    # Standard network configuration.
    networking.networkmanager.enable = true;
    
    # --- Firewall ---
    networking.firewall.enable = true;
  };

}
