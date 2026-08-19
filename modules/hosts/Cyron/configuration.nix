# modules/hosts/Cyron/configuration.nix
{ self, inputs, lib, ... }: {

  flake.nixosConfigurations.Cyron = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = [
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.disko
      self.nixosModules.cyronConfiguration
    ];
  };

  flake.nixosModules.cyronConfiguration = { pkgs, ... }: {
    imports = [
      (self.nixosModules.cyronHardware or {})
      (self.nixosModules.cyronNvidia or {})
    ] 
    # Automatically wire every general system module
    ++ (builtins.attrValues (self.nixosModules.system or {}));

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages.latest;

    networking.hostName = "Cyron";
    time.timeZone = "Europe/Istanbul";
    i18n.defaultLocale = "en_US.UTF-8";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    hardware.graphics.enable = true;
    system.stateVersion = "26.05";

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.hakanalp = {
      home.stateVersion = "26.05";
      # Recursively auto-import every dendritic home module into the user environment
      imports = lib.collect builtins.isAttrs (self.homeModules or {});
    };
  };
}
