{ ... }: {
  flake.homeModules.terminals.alacritty = {
    programs.alacritty.enable = true;
  };
}
