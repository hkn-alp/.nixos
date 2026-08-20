{ ... }: {
  flake.modules.apps.development.texlive = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.texlive.combined.scheme-full ];
  };
}
