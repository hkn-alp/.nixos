{ ... }: {
  flake.modules.apps.office.simpleScan = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.simple-scan ];
  };
}
