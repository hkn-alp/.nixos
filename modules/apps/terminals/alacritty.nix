# modules/apps/terminals/alacritty.nix
{ ... }: {
  flake.modules.apps.terminals.alacritty = [
    ({ pkgs, ... }: {
      environment.systemPackages = [ pkgs.alacritty ];
    })
  ];
}
