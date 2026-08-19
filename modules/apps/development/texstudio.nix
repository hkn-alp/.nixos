{ ... }: {
  flake.nixosModules.apps.development.texstudio = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.texstudio ];
  };
}
