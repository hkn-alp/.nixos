# modules/apps/development/jupyter.nix
{ ... }: {
  flake.modules.apps.development.jupyter = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.jupyter ];
    })
  ];
}
