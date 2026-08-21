# modules/apps/media/gimp.nix
{ ... }: {
  flake.modules.apps.media.gimp = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.gimp ];
    })
  ];
}
