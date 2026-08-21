# modules/system/bluetooth.nix
{ self, inputs, ... }: {
  flake.modules.system.bluetooth = [
    ({ config, pkgs, ... }: {
      # === 1. BLUETOOTH DAEMONS ===
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
    })
  ];
}
