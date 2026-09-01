{ config, pkgs, ... }: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # Enable thumbnail support for images
  services.tumbler.enable = true; 
  
  # Enable Trash, removable media, and network drive support
  services.gvfs.enable = true; 
}
