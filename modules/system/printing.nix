modules/system/printing.nix
{ config, pkgs, ... }:

{
  # === 1. PRINTER DAEMONS ===
  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Optional: Enable auto-discovery of network printers (Wi-Fi printers)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
