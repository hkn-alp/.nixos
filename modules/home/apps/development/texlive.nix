{ ... }: {
  flake.homeModules.development.texlive = { pkgs, ... }: {
    home.packages = [ pkgs.texlive.combined.scheme-full ];
  };
}
