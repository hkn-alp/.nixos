{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # GNOME
    gnome-text-editor
    gnome-disk-utility
    gnome-network-displays
    papers
    simple-scan
    showtime # Video Player
    decibels # Audio Player
    loupe # Image Viewer
    snapshot # Camera
    gnome-sound-recorder # Sound Recorder
    
    # Cinnamon
    superlight # System Monitor
  ];
}
