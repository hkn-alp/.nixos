{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.julia-bin ];
}
