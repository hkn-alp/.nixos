{ config, pkgs, ... }: {
  environment.systemPackages = [ pkgs.localsend ];

  # Bind LocalSend ports STRICTLY to the Tailscale interface for mesh-only transfers
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };
}
