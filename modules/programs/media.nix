{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    celluloid # GTK Video Player
    loupe # GNOME Image Viewer
    snapshot # GNOME Camera
    gnome-sound-recorder # GNOME Sound Recorder
  ];
}
