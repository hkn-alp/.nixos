{ ... }: {
  flake.homeModules.development.julia = { pkgs, ... }: {
    home.packages = [ pkgs.julia-bin ];
  };
}
