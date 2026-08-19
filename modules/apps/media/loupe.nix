{ ... }: {
  flake.nixosModules.apps.media.loupe = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.loupe ];
  };
}
