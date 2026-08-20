{ ... }: {
  flake.modules.apps.browsers.firefox = { pkgs, ... }: {
    programs.firefox.enable = true;
  };
}
