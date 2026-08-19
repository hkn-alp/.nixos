{ ... }: {
  flake.nixosModules.apps.media.snapshot = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.snapshot ];
  };
}
