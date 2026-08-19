{ ... }: {
  flake.nixosModules.apps.media.soundRecorder = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gnome-sound-recorder ];
  };
}
