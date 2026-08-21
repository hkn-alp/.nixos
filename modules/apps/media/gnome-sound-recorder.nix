# modules/apps/media/gnome-sound-recorder.nix
{ ... }: {
  flake.modules.apps.media.soundRecorder = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.gnome-sound-recorder ];
    })
  ];
}
