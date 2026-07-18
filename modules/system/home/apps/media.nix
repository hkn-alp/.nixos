# modules/home/apps/media.nix
{ pkgs, ... }:

{
  # === 1. MEDIA & DESIGN ===
  
  home.packages = with pkgs; [
    gimp                  # GIMP
    obs-studio            # OBS Studio
    loupe                 # Image Viewer
    mpv                   # Video Player
    snapshot              # Camera App
    gnome-sound-recorder  # Sound Recorder
  ];
}
