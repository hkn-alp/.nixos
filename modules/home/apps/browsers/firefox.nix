{ ... }: {
  flake.homeModules.browsers.firefox = {
    programs.firefox.enable = true;
  };
}
