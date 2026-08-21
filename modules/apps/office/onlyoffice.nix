# modules/apps/office/onlyoffice.nix
{ ... }: {
  flake.modules.apps.office.onlyoffice = [
    ({ pkgs, lib, ... }: {
      environment.systemPackages = [ pkgs.onlyoffice-bin ];
    })
  ];
}
