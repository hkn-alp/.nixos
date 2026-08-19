{ ... }: {
  flake.homeModules.media.loupe = { pkgs, ... }: {
    home.packages = [ pkgs.loupe ];
  };
}
