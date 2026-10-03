{ config, pkgs, inputs, ... }: {

  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disko.nix
    ./keyboard.nix
    ./nvidia.nix
    ../../modules/profiles/workstation.nix
  ];

  networking.hostName = "Cyron";
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "26.05";
}
