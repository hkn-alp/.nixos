{ ... }: {
  flake.homeModules.media.soundRecorder = { pkgs, ... }: {
    home.packages = [ pkgs.gnome-sound-recorder ];
  };
}
