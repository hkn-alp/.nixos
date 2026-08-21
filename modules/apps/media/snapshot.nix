# modules/apps/media/snapshot.nix
{ ... }: {
  flake.modules.apps.media.snapshot = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.snapshot ];
    })
  ];
}
