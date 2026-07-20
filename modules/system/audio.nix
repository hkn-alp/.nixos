# modules/system/audio.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.audio = { config, pkgs, ... }: {
    
    # === 1. AUDIO SUBSYSTEM ===
    
    # --- PipeWire ---
    # The modern Linux audio server, required for proper Wayland audio management.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

}
