{ ... }: {
  flake.modules.apps.development.jupyter = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.jupyter ];
  };
}
