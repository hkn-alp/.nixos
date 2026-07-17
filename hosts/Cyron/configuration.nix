# hosts/Cyron/configuration.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    # === 1. HARDWARE CONFIGURATION ===
    # Auto-generated hardware scan for the physical laptop.
    ./hardware-configuration.nix
    
    # === 2. SYSTEM MODULES ===
    # Root-level daemons, permissions, and core OS interfaces.
    ../../modules/system/users.nix
    ../../modules/system/network.nix
    ../../modules/system/audio.nix
    
    # Wayland compositor (Niri) and shell (Noctalia) system-level engines.
    ../../modules/shell
  ];

  # === 3. HOST-SPECIFIC SETTINGS ===
  
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
  # Provides native Wayland support without proprietary NVIDIA bloat.
  hardware.graphics.enable = true;

  # === 4. USER SPACE ===
  
  # --- Home Manager ---
  # Hand off user-specific configurations (Dotfiles, UI, Themes).
  # Note: 'inputs' is passed down automatically via flake.nix extraSpecialArgs.
  home-manager.users.hakanalp = import ../../modules/home/hakanalp.nix;

  # === 5. SYSTEM STATE ===
  
  # --- State Version ---
  # The permanent birth certificate of the machine. Do not change this number.
  system.stateVersion = "26.05";
}
