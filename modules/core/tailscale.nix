{ config, pkgs, ... }: {
  # Inject jq only when Tailscale is enabled
  environment.systemPackages = [ pkgs.jq ];

  # Enable Tailscale
  services.tailscale.enable = true;

  # Required for Tailscale to route correctly on NixOS
  networking.firewall.checkReversePath = "loose";
}
