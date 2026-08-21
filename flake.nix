{
  description = "Clean and Simple NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add Noctalia, Niri, and other inputs here as needed
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      
      Cyron = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Passes inputs down to all modules so you can use them anywhere
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

    };
  };
}
