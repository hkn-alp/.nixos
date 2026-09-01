{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tier 2: Declarative Flatpak Management
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      
      Cyron = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/Cyron/default.nix
        ];
      };

      VM = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/VM/default.nix
        ];
      };

      # Template for bootstrapping new machines
      # NewHost = nixpkgs.lib.nixosSystem {
        # system = "x86_64-linux"; # Change to "aarch64-linux" for ARM processors
        # specialArgs = { inherit inputs; };
        # modules = [
          # ./hosts/NewHost/default.nix
        # ];
      # };

    };
  };
}
