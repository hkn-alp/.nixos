{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.jupyter ];
}
