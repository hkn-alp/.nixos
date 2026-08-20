{ ... }: {
  flake.modules.apps.development.distrobox = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.distrobox ];
    virtualisation.podman.enable = true;
  };
}
