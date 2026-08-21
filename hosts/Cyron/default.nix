{ config, pkgs, inputs, ... }: {
  
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disko.nix
    ./nvidia.nix
    ./modules.nix
  ];

  # Host-specific settings go directly here
  networking.hostName = "Cyron";
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "26.05";
}
