{ ... }: {
  flake.modules.apps.browsers.firefox = {
    programs.firefox.enable = true;
  };
}
