{ ... }: {
  flake.homeModules.development.jupyter = { pkgs, ... }: {
    home.packages = [ pkgs.jupyter ];
  };
}
