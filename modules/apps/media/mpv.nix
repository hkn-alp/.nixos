{ ... }: {
  flake.modules.apps.media.mpv = { pkgs, ... }: {
    programs.mpv.enable = true;
  };
}
