{ ... }: {
  flake.nixosModules.apps.development.jupyter = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.jupyter ];
  };
}
