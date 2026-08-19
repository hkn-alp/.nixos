{ ... }: {
  flake.homeModules.media.mpv = {
    programs.mpv.enable = true;
  };
}
