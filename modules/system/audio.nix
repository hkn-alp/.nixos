{ self, inputs, ... }: {

  flake.modules.system.audio = [
    ({ config, pkgs, ... }: {
      
      # === 1. AUDIO SUBSYSTEM ===
      
      # --- PipeWire ---
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      
    })
  ];

}
