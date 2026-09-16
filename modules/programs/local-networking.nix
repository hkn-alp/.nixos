{ pkgs, ... }: {

  # --- Local File Transfer (LocalSend) ---
  programs.localsend = {
    enable = true;
    openFirewall = true; # Automatically handles TCP/UDP 53317
  };

  # --- Device GUIs ---
  environment.systemPackages = with pkgs; [
    system-config-printer
    gnome-network-displays
  ];
}
