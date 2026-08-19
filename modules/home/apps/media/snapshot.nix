{ ... }: {
  flake.homeModules.media.snapshot = { pkgs, ... }: {
    home.packages = [ pkgs.snapshot ];
  };
}
