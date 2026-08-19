{ ... }: {
  flake.nixosModules.apps.terminals.alacritty = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.alacritty ];
  };
}
