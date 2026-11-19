{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xdg-terminal-exec
    gnome-text-editor
    superlight
    lm_sensors
    gnome-disk-utility
  ];
  
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
