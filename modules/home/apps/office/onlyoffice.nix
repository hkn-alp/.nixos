{ ... }: {
  flake.homeModules.office.onlyoffice = { pkgs, ... }: {
    home.packages = [ pkgs.onlyoffice-bin ];
  };
}
