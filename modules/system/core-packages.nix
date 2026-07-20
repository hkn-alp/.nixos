# modules/system/core-packages.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.corePackages = { pkgs, ... }: {
    
    # === 1. EMERGENCY & CORE UTILITIES ===
    
    # These are root-level system lifesavers that are always available.
    environment.systemPackages = with pkgs; [
      wget
      curl
      git
      unzip
      ripgrep
      btop           # Terminal-based resource monitor
      pciutils       # For 'lspci' hardware debugging
      usbutils       # For 'lsusb'
      wl-clipboard   # Wayland copy/paste support
      
      # Root-level GUI applications
      gparted        # Partition manager (requires sudo)
    ];
  };

}
