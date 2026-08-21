# modules/apps/media/obs-studio.nix
{ ... }: {
  flake.modules.apps.media.obsStudio = [
    ({ pkgs, ... }: {
      programs.obs-studio.enable = true;
    })
  ];
}
