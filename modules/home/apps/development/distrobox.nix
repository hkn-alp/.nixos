{ ... }: {
  flake.homeModules.development.distrobox = { pkgs, ... }: {
    home.packages = [ pkgs.distrobox ];
  };
}
