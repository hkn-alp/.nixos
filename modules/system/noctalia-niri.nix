# modules/system/noctalia-niri.nix
{ self, inputs, ... }: {
  
  # === 1. THE SYSTEM DESKTOP MODULE ===
  flake.modules.system.noctalia-niri = { config, pkgs, lib, ... }: {
    imports = [ 
      inputs.noctalia.nixosModules.default 
      inputs.noctalia-greeter.nixosModules.default
    ];
    
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      recommendedServices.enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-niri;
    };
    
    programs.noctalia-greeter = {
      enable = true;
      greeter-args = "session niri";
    };

    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri4noctalia;
    };
  };

  # === 2. THE WRAPPED PACKAGES ===
  perSystem = { pkgs, lib, self', ... }: {
    packages.noctalia-niri = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = (builtins.fromTOML (builtins.readFile ./noctalia-niri-config/noctalia-config.toml)).settings;
    };

    packages.niri4noctalia = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      };
      extraConfig = builtins.readFile ./noctalia-niri-config/niri-config.kdl;
    };
  };
}
