# modules/system/nvidia.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.nvidia = { config, pkgs, lib, ... }: {
    
    # === 1. GRAPHICS SUBSYSTEM ===
    
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load the NVIDIA driver for display servers
    services.xserver.videoDrivers = [ "nvidia" ];

    # === 2. NVIDIA SPECIFIC CONFIGURATION ===
    
    hardware.nvidia = {
      # Modesetting is required for Wayland compositors (Niri, GNOME) to function properly.
      modesetting.enable = true;

      # Enable dynamic power management. Turns off the GPU when not in use.
      # This requires a Turing architecture GPU (which the GTX 1650 is).
      powerManagement.finegrained = true;

      # Explicitly force the proprietary drivers, as the open-source ones perform poorly on TU117.
      open = false;

      # Enable the NVIDIA settings menu, accessible via `nvidia-settings`.
      nvidiaSettings = true;
      
      # === 3. PRIME OFFLOAD (HYBRID GRAPHICS) ===
      prime = {
        # Enable offload mode to let the iGPU handle default tasks
        offload = {
          enable = true;
          # Generates an `nvidia-offload` script to launch apps on the dGPU
          enableOffloadCmd = true; 
        };

        # -------------------------------------------------------------
        # IMPORTANT: YOU MUST REPLACE THESE WITH YOUR EXACT PCI BUS IDs
        # -------------------------------------------------------------
        intelBusId = "PCI:0:2:0";  # Use this if you have an Intel CPU
        # amdgpuBusId = "PCI:0:2:0"; # Uncomment and use this instead if you have an AMD CPU
        nvidiaBusId = "PCI:1:0:0"; # The GTX 1650
      };
    };
  };
}
