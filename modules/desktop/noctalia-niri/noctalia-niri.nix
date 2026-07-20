# modules/desktop/noctalia-niri/noctalia-niri.nix
{ self, inputs, ... }: {
  
  # === 1. THE SYSTEM MODULE ===
  flake.nixosModules.system.desktop = { pkgs, lib, config, ... }: {
    imports = [ 
      inputs.noctalia.nixosModules.default 
      inputs.noctalia-greeter.nixosModules.default
    ];
    
    # Enable Noctalia
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      recommendedServices.enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-niri;
      
      settings = { launch_apps_as_systemd_services = true; };
    };
    
    # Enable Noctalia Greeter
    programs.noctalia-greeter = {
      enable = true;
      greeter-args = "session niri";
    };

    # Enable Niri alongside it
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri4noctalia;
    };
  };

  # === 2. THE WRAPPED PACKAGES ===
  perSystem = { pkgs, lib, self', ... }: {
    
    # Build Noctalia
    packages.noctalia-niri = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = (builtins.fromTOML (builtins.readFile ./noctalia-config.toml)).settings;
    };

    # Build Niri
    packages.niri4noctalia = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      
      settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      };
      
      # Now pointing to the unified configuration file
      extraConfig = builtins.readFile ./niri-config.kdl;
    };
  };
}
