# modules/home/profiles/desktop.nix
{ pkgs, inputs, ... }:

{
  # === 1. EXTERNAL MODULES ===
  
  # Import Noctalia's user-level module from the flake inputs.
  imports = [ inputs.noctalia.homeModules.default ];

  # === 2. UI CONFIGURATION ===
  
  # --- Noctalia ---
  programs.noctalia = {
    settings = {
      # Prevents background apps from dying if the shell is restarted.
      launch_apps_as_systemd_services = true;
      
      # Additional bar layouts and widget colors will go here.
    };
  };

  # --- Niri ---
  # Links a local config.kdl directly to ~/.config/niri/config.kdl
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
}
