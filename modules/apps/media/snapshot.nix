{ ... }: {
  flake.modules.apps.media.snapshot = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.snapshot ];
  };
}
