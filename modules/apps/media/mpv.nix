# modules/apps/media/mpv.nix
{ ... }: {
  flake.modules.apps.media.mpv = [
    ({ pkgs, ... }: {
      programs.mpv.enable = true;
    })
  ];
}
