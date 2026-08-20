{ ... }: {
  flake.modules.apps.media.obsStudio = { pkgs, ... }: {
    programs.obs-studio.enable = true;
  };
}
