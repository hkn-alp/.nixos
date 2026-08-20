# modules/system/audio.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.audio = { config, pkgs, ... }: {
    
    # === 1. AUDIO SUBSYSTEM ===
    
    # --- PipeWire ---
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

}
