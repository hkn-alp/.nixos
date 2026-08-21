# modules/apps/development/texstudio.nix
{ ... }: {
  flake.modules.apps.development.texstudio = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.texstudio ];
    })
  ];
}
