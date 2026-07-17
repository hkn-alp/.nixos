# flake.nix
{
  description = "Flake Configuration for NixOS + Noctalia + Niri Setup";

  # === 1. GLOBAL NIX CONFIGURATION ===
  nixConfig = {
    # Use Cachix binary cache to prevent compiling the shell from scratch.
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  # === 2. INPUTS (SOFTWARE SOURCES) ===
  inputs = {
    # --- Core OS ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Home Manager ---
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # Tell Home Manager to strictly follow the Nixpkgs version defined above.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Noctalia Environment ---
    # Track the 'cachix' branch to guarantee pre-built binaries.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
  };

  # === 3. OUTPUTS (BUILD INSTRUCTIONS) ===
  outputs = { self, nixpkgs, home-manager, noctalia, noctalia-greeter, ... } @ inputs: {
    
    nixosConfigurations = {
      
      # --- Cyron Host Configuration ---
      # Build command: sudo nixos-rebuild switch --flake ~/my-nixos#Cyron
      Cyron = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # Pass the 'inputs' variable to all system modules (e.g., /modules/shell/default.nix).
        specialArgs = { inherit inputs; };

        modules = [
          # --- System Entry Point ---
          ./hosts/Cyron/configuration.nix
          
          # --- Home Manager Integration ---
          # Initialize Home Manager as a system-level module.
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # Pass the 'inputs' variable down to user space (e.g., /modules/home/hakanalp.nix).
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
