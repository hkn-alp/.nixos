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
    gnome-disk-utility
    resources
    lm_sensors
    baobab
  ];
}
