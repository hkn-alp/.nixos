{ ... }: {
  flake.nixosModules.apps.media.obsStudio = {
    programs.obs-studio.enable = true;
  };
}
