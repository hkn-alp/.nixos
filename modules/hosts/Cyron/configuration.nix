# modules/hosts/Cyron/configuration.nix
{ self, inputs, ... }: {

  # Expose the top-level NixOS system for flake build targets
  flake.nixosConfigurations.Cyron = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = [
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      ./disko-config.nix
      self.nixosModules.cyronConfiguration
    ];
  };

  flake.nixosModules.cyronConfiguration = { pkgs, config, lib, ... }: {
    imports = [
      # Auto-generated hardware scan (if available in live install, else disko handles mounts)
      (self.nixosModules.cyronHardware or {})
    ] 
    ++ (builtins.attrValues (self.nixosModules.system or {}));

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages.latest;

    networking.hostName = "Cyron";
    time.timeZone = "Europe/Istanbul";
    i18n.defaultLocale = "en_US.UTF-8";

    # Experimental features enabled system-wide
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    hardware.graphics.enable = true;
    system.stateVersion = "26.05";

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.hakanalp = {
      home.stateVersion = "26.05";
      imports = [
        ../../home/apps
      ];
    };
  };
}
