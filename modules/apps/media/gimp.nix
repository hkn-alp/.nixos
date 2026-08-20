{ ... }: {
  flake.modules.apps.media.gimp = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gimp ];
  };
}
