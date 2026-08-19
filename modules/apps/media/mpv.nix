{ ... }: {
  flake.nixosModules.apps.media.mpv = {
    programs.mpv.enable = true;
  };
}
