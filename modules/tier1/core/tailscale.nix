{ config, pkgs, ... }: {
  services.tailscale.enable = true;

  # Required for Tailscale to route correctly on NixOS
  networking.firewall.checkReversePath = "loose";
}
