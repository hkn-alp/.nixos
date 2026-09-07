{ config, pkgs, inputs, ... }: {

  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disko.nix
    ./nvidia.nix
    ../../modules/profiles/workstation.nix
  ];

  networking.hostName = "Cyron";
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "26.05";
}
