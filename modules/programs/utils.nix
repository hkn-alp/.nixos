{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xdg-terminal-exec
    nemo
    gnome-text-editor
    kdePackages.kate
    resources
    lm_sensors
    gnome-disk-utility
  ];
  
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
