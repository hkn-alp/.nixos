{ ... }: {
  flake.homeModules.media.obsStudio = {
    programs.obs-studio.enable = true;
  };
}
