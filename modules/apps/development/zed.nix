# modules/apps/development/zed.nix
{ ... }: {
  flake.modules.apps.development.zed = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.zed-editor ];
    })
  ];
}
