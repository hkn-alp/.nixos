{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.nautilus ];
  programs.nautilus-open-any-terminal.enable = true;
}
