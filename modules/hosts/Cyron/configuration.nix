# modules/hosts/Cyron/configuration.nix
{ self, ... }: {

  flake.nixosModules.cyronConfiguration = { pkgs, config, lib, ... }: {
    
    # === 1. SYSTEM MODULES & IMPORTS ===
    imports = [
      # Auto-generated hardware scan for the physical laptop.
      self.nixosModules.cyronHardware
    ] 
    # Automatically import EVERY other system module defined in the flake
    ++ (builtins.attrValues self.nixosModules.system);

    # === 2. HOST-SPECIFIC SETTINGS ===
    
    # --- Bootloader ---
    # Enable the systemd-boot EFI bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages.latest;

    # --- System Identity ---
    # Define the network hostname for this specific machine.
    networking.hostName = "Cyron";

    # --- Timezone & Locale ---
    # Define regional settings for time and language.
    time.timeZone = "Europe/Istanbul";
    i18n.defaultLocale = "en_US.UTF-8";

    # --- Graphics (GTX 1650) ---
    # Enable open-source Mesa/Nouveau drivers built into the kernel.
    hardware.graphics.enable = true;

    # === 3. SYSTEM STATE ===
    
    # --- State Version ---
    # The permanent birth certificate of the machine. Do not change this number.
    system.stateVersion = "26.05";
    
    # === 4. USER SPACE ===
    
    # --- Home Manager ---
    # Hand off user-specific configurations (Dotfiles, UI, Themes).
    home-manager.users.hakanalp = {
      # Automatically import all Home modules defined in the flake
      imports = builtins.attrValues self.homeModules;
    };
  };

}
