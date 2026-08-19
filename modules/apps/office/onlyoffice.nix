{ ... }: {
  flake.nixosModules.apps.office.onlyoffice = { pkgs, lib, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "onlyoffice-bin"
    ];
    environment.systemPackages = [ pkgs.onlyoffice-bin ];
  };
}
