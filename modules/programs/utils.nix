{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nautilus
    xdg-terminal-exec
    gnome-text-editor
    gnome-disk-utility
    resources
    lm_sensors
    baobab
    file-roller
  ];
}
