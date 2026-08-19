{ ... }: {
  flake.nixosModules.apps.development.zed = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.zed-editor ];
  };
}
