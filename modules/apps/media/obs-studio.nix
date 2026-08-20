{ ... }: {
  flake.modules.apps.media.obsStudio = {
    programs.obs-studio.enable = true;
  };
}
