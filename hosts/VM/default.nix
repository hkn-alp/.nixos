{ config, pkgs, inputs, ... }: {

  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disko.nix
    ../../modules/profiles/vm.nix
  ];

  networking.hostName = "VM";
  time.timeZone = "Europe/Istanbul";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8";        # Starts week on Monday & enforces 24-hour clock
      LC_MEASUREMENT = "en_GB.UTF-8"; # Metric units (cm, m, kg, km)
      LC_PAPER = "en_GB.UTF-8";       # A4 paper format instead of US Letter
      LC_NUMERIC = "en_US.UTF-8";     # Retains dot (.) as decimal point instead of comma
    };
  };

  system.stateVersion = "26.05";
}
