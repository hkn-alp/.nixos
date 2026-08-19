# modules/system/gaming.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.gaming = { config, pkgs, ... }: {
    
    # === 1. GAMING SUBSYSTEM ===
    
    # --- Performance ---
    # Enable Feral Interactive's GameMode for system optimizations during gameplay
    programs.gamemode.enable = true;
    
    # --- Graphics Drivers ---
    # Steam and many older games require 32-bit OpenGL support
    hardware.graphics.enable32Bit = true;

    # --- Steam ---
    programs.steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true; 
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true; 
    };

    # --- Launchers, Emulators & Comms ---
    environment.systemPackages = with pkgs; [
      heroic             # Launcher for Epic Games / GOG
      lutris             # General game manager/runner
      protonup-qt        # GUI for managing custom Proton versions (e.g., GE-Proton)
      
      # RetroArch with bundled cores
      (retroarch.override {
        cores = with libretro; [
          puae           # Amiga 500
          scummvm        # Classic point-and-click adventures
          dosbox         # MS-DOS
        ];
      })
    ];
  };
}
