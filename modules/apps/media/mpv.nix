{ ... }: {
  flake.modules.apps.media.mpv = {
    programs.mpv.enable = true;
  };
}
