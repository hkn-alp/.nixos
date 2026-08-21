# modules/hosts/VM/configuration.nix
{ self, inputs, lib, ... }: {

  flake.nixosConfigurations.VM = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = [
      inputs.disko.nixosModules.disko
      self.nixosModules.VM-config
      self.nixosModules.VM-disko
    ];
  };

  flake.nixosModules.VM-config = { pkgs, ... }: {
    imports = [
      # Directly import the raw file from outside the modules tree
      ../../../hardware/VM.nix
    ] 
    ++ (lib.collect builtins.isFunction (self.modules.system or {}))
    ++ (lib.collect builtins.isFunction (self.modules.apps or {}));
    
    # Add this line to globally allow unfree packages and prevent option conflicts
    nixpkgs.config.allowUnfree = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "VM";
    time.timeZone = "Europe/Istanbul";
    i18n.defaultLocale = "en_US.UTF-8";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    hardware.graphics.enable = true;
    system.stateVersion = "26.05";
  };
}
