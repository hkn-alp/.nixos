{ config, pkgs, inputs, ... }: {

  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disko.nix
    ../../modules/profiles/vm.nix
  ];

  networking.hostName = "VM";
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "26.05";
}
