{ ... }: {
  flake.modules.apps.media.loupe = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.loupe ];
  };
}
