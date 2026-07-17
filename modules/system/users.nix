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
    
    # 'wheel' = sudo access
    # 'networkmanager' = Wi-Fi controls
    # 'video' / 'audio' / 'input' = Hardware permissions
    # 'docker' / 'dialout' = Engineering and container permissions
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "docker"
      "dialout"
    ];
  };
}
