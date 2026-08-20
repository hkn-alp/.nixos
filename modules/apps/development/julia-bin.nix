{ ... }: {
  flake.modules.apps.development.julia = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.julia-bin ];
  };
}
