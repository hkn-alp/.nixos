{ pkgs, ... }: {
  
  # 1. Enable Podman (The container engine)
  virtualisation.podman = {
    enable = true;
    
    # Enable DNS resolution for containers
    defaultNetwork.settings.dns_enabled = true;
    
    # Prune unused container images weekly to save disk space
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # 2. Install Distrobox
  environment.systemPackages = with pkgs; [ 
    distrobox
  ];
}
