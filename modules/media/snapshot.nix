{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.snapshot ];
}
