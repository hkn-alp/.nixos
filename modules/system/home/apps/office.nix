# modules/home/apps/office.nix
{ pkgs, ... }:

{
  # === 1. OFFICE & UTILITIES ===
  
  home.packages = with pkgs; [
    onlyoffice-bin
    simple-scan
  ];
}
