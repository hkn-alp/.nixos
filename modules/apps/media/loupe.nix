# modules/apps/media/loupe.nix
{ ... }: {
  flake.modules.apps.media.loupe = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.loupe ];
    })
  ];
}
