{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xdg-terminal-exec
    gnome-text-editor
    resources
    lm_sensors
    baobab
  ];
  
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
