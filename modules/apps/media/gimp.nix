{ ... }: {
  flake.nixosModules.apps.media.gimp = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gimp ];
  };
}
