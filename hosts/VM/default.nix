{ config, pkgs, inputs, ... }: {
  
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disko.nix
    ../../modules/profiles/workstation.nix
  ];

  networking.hostName = "VM";
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "26.05";
}
