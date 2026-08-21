{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    unzip
    ripgrep
    btop           
    pciutils       
    usbutils       
    wl-clipboard   
    gparted        
  ];
}
