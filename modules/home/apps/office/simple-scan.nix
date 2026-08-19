{ ... }: {
  flake.homeModules.office.simpleScan = { pkgs, ... }: {
    home.packages = [ pkgs.simple-scan ];
  };
}
