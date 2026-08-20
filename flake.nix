# flake.nix
{
  description = "Flake Configuration for NixOS + Noctalia + Niri Setup";

  nixConfig = {
    extra-substituters = [ 
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ lib, ... }: {
    
    # 1. Imports can safely stay at the top level
    imports = [ (inputs.import-tree ./modules) ];

    # 2. The explicit options declaration
    options = {
      flake.modules = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Custom heavily nested modules tree";
      };
    };

    # 3. All assigned configuration values must move inside here
    config = {
      systems = [ "x86_64-linux" ];
    };

  });
}
