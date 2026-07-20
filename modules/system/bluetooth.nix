# modules/system/bluetooth.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.bluetooth = { config, pkgs, ... }: {
    
    # === 1. BLUETOOTH DAEMONS ===
    
    # Enable the Bluetooth hardware radio.
    hardware.bluetooth.enable = true;
    
    # Powers up the default Bluetooth controller on boot.
    hardware.bluetooth.powerOnBoot = true;
  };

}
