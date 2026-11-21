{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    signal-desktop
    spotify
    joplin-desktop
  ];

  # --- Local File Transfer (LocalSend) ---
  programs.localsend = {
    enable = true;
    openFirewall = true; # Automatically handles TCP/UDP 53317
  };
}
