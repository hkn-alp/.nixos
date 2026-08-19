{ ... }: {
  flake.nixosModules.apps.browsers.firefox = {
    programs.firefox.enable = true;
  };
}
