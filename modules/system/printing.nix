# modules/system/printing.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.printing = { config, pkgs, ... }: {
    
    # === 1. PRINTER DAEMONS ===
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

}
