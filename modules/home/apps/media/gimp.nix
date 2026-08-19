{ ... }: {
  flake.homeModules.media.gimp = { pkgs, ... }: {
    home.packages = [ pkgs.gimp ];
  };
}
