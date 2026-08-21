# modules/apps/browsers/firefox.nix
{ ... }: {
  flake.modules.apps.browsers.firefox = [
    ({ pkgs, ... }: {
      programs.firefox.enable = true;
    })
  ];
}
