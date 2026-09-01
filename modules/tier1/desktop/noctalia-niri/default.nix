{ pkgs, lib, inputs, ... }: 
{
  # --- Noctalia Shell ---
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
    
    # Inject TOML configuration
    package = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = builtins.fromTOML (builtins.readFile ./noctalia-config.toml);
    };
  };

  # --- Noctalia Greeter ---
  services.displayManager.noctalia-greeter = {
    enable = true;
    
    # Arguments to add to the noctalia-greeter-session invocation 
    extraArgs = [ "session" "niri" ];
  };

  # --- Niri Window Manager ---
  programs.niri = {
    enable = true;
    package = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      };
      extraConfig = builtins.readFile ./niri-config.kdl;
    };
  };
}
