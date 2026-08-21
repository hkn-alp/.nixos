# modules/apps/development/texlive.nix
{ ... }: {
  flake.modules.apps.development.texlive = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.texlive.combined.scheme-full ];
    })
  ];
}
