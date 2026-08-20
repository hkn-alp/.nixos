# modules/system/bluetooth.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.bluetooth = { config, pkgs, ... }: {
    
    # === 1. BLUETOOTH DAEMONS ===
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };

}
