{ pkgs, ... }:

{
  # Enable Thunar file manager
  programs.thunar.enable = true;

  # Required to save preferences if you are not using the full Xfce desktop
  programs.xfconf.enable = true;

  # Essential services for mounting, trash, and remote filesystems
  services.gvfs.enable = true;

  # Thumbnail support for images
  services.tumbler.enable = true;

  # Optional: Recommended plugins for archives and volume management
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];
}
