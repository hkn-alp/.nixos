# modules/system/users.nix
{ config, pkgs, ... }:

{
  # === 1. USER ACCOUNTS ===
  
  # --- Hakan's Profile ---
  users.users.hakanalp = {
    isNormalUser = true;
    
    # Acts as the Full Name / GECOS field on the login screen
    description = "Hakan Alparslan";
    
    # Set a starting password for the first boot
    initialPassword = "password";
    
    extraGroups = [
      # 'wheel' = sudo access
      "wheel"
      # 'networkmanager' = Wi-Fi controls
      "networkmanager"
      # 'video' / 'audio' / 'input' = Hardware permissions
      "video"
      "audio"
      "input"
      # 'docker' / 'dialout' = Engineering and container permissions
      "docker"
      "dialout"
    ];
  };
}
