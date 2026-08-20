# modules/hosts/Cyron/configuration.nix
{ self, inputs, lib, ... }: {

  flake.nixosConfigurations.Cyron = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = [
      inputs.disko.nixosModules.disko
      self.nixosModules.Cyron-config
      self.nixosModules.Cyron-disko
      self.nixosModules.Cyron-nvidia
    ];
  };

  flake.nixosModules.Cyron-config = { pkgs, ... }: {
    imports = [
      # Directly import the raw file from outside the modules tree
      ../../../hardware/Cyron.nix
    ] 
    ++ (lib.collect builtins.isFunction (self.modules.system or {}))
    ++ (lib.collect builtins.isFunction (self.modules.apps or {}));

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "Cyron";
    time.timeZone = "Europe/Istanbul";
    i18n.defaultLocale = "en_US.UTF-8";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    hardware.graphics.enable = true;
    system.stateVersion = "26.05";
  };
}
