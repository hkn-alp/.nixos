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

    # --- Dendritic Framework ---
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    
    # --- Wrappers ---
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

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
  # import-tree automatically evaluates every file in ./modules
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
    (inputs.import-tree ./modules);
}
