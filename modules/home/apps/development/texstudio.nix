{ ... }: {
  flake.homeModules.development.texstudio = { pkgs, ... }: {
    home.packages = [ pkgs.texstudio ];
  };
}
