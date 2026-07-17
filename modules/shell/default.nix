# modules/shell/default.nix
{ pkgs, inputs, ... }:

{
  # === 1. EXTERNAL MODULES ===
  
  # Import Noctalia's system-level module from the flake inputs.
  imports = [ inputs.noctalia.nixosModules.default ];

  # === 2. COMPOSITOR ===
  
  # --- Niri ---
  # Installs Niri, sets up Wayland environment variables, and adds it to the Display Manager.
  programs.niri.enable = true;

  # === 3. DESKTOP SHELL ===
  
  # --- Noctalia ---
  # Enables system-level hooks for Noctalia to read power, Bluetooth, and Wi-Fi data.
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
  };
}
