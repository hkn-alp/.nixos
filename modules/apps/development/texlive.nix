{ ... }: {
  flake.nixosModules.apps.development.texlive = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.texlive.combined.scheme-full ];
  };
}
