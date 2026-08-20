# modules/system/network.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.network = { config, pkgs, ... }: {
    
    # === 1. NETWORKING DAEMONS ===
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
  };

}
