# modules/system/users.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.users = { config, pkgs, ... }: {
    
    # === 1. USER ACCOUNTS ===
    
    # --- Hakan's Profile ---
    users.users.hakanalp = {
      isNormalUser = true;
      
      # Acts as the Full Name / GECOS field on the login screen
      description = "Hakan Alparslan";
      
      # Set a starting password for the first boot
      initialPassword = "1234";
      
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

    # --- Guest Profile ---
    users.users.guest = {
      isNormalUser = true;
      
      # Acts as the Full Name / GECOS field on the login screen
      description = "Guest User";
      
      # Set a starting password for the guest account
      initialPassword = "1234";
      
      extraGroups = [
        # 'networkmanager' = Wi-Fi controls
        "networkmanager"
        # 'video' / 'audio' / 'input' = Hardware permissions
        "video"
        "audio"
        "input"
        # Note: Explicitly omitting 'wheel' and 'docker' for security
      ];
    };
  };

}
