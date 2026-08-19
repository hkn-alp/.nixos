{ ... }: {
  flake.homeModules.development.zed = { pkgs, ... }: {
    home.packages = [ pkgs.zed-editor ];
  };
}
