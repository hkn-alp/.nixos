# modules/apps/development/julia-bin.nix
{ ... }: {
  flake.modules.apps.development.julia = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.julia-bin ];
    })
  ];
}
