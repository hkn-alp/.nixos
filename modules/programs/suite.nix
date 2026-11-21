{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # GNOME
    gnome-text-editor # Text Editor
    gnome-disk-utility # Disk Utility
    gnome-network-displays # Miracast
    papers # Document Viewer
    simple-scan # Scanner
    showtime # Video Player
    decibels # Audio Player
    loupe # Image Viewer
    snapshot # Camera
    gnome-sound-recorder # Sound Recorder

    # Cinnamon
    superlight # System Monitor

    # GTK
    system-config-printer # Print Manager
  ];
}
