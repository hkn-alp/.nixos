{
  description = "NixOS Flake Configuration";

  # 1. Global Nix Configuration
  nixConfig = {
    # Using cache instead of compiling the shell from scratch
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  # 2. Inputs (The Software Sources)
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # Tells Home Manager to use exact version of Nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # Noctalia Greeter
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
  };

  # 3. Outputs (The Build Instructions)
  outputs = { self, nixpkgs, home-manager, noctalia, noctalia-greeter, ... } @ inputs: {
    
    nixosConfigurations = {
      # The name "Cyron" corresponds to the build command:
      # sudo nixos-rebuild switch --flake ~/my-nixos#Cyron
      Cyron = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # This is the secret sauce: it passes the 'inputs' variable to all 
        # system modules so files like /modules/shell/default.nix 
        # can access inputs.noctalia
        specialArgs = { inherit inputs; };

        modules = [
          # The entry point to system configuration
          # The name "Cyron" corresponds to the build command:
          # sudo nixos-rebuild switch --flake ~/my-nixos#Cyron
          ./hosts/Cyron/configuration.nix
          
          # Initialize Home Manager as a system-level module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # This passes the 'inputs' variable down to user space ('hakanalp' in this case)
            # so modules/home/hakanalp.nix can also use external Flake modules
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
