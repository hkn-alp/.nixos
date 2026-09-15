{ config, pkgs, ... }: {
  # --- File Management (Thunar) ---
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    # Hardware & Disk Utilities
    gnome-disk-utility
    resources
    lm_sensors
    gdu
    baobab

    # Networking & Transfer
    system-config-printer
    gnome-network-displays
  ];
}
