{ ... }: {
  flake.modules.apps.development.texstudio = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.texstudio ];
  };
}
