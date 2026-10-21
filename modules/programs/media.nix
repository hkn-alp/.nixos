{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    showtime # GNOME Video Player
    decibels # GNOME Audio Player
    loupe # GNOME Image Viewer
    snapshot # GNOME Camera
    gnome-sound-recorder # GNOME Sound Recorder
  ];
}
