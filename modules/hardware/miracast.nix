{ ... }: {
  # Open the ports required for Miracast / Wi-Fi Direct streaming
  networking.firewall.allowedTCPPorts = [ 7236 7250 ];
  networking.firewall.allowedUDPPorts = [ 7236 5353 ];
}
