{ pkgs, ... }: {
  # 1. Background SMART daemon & desktop notifications
  services.smartd = {
    enable = true;
    notifications.systembus-notify.enable = true;
  };

  # 2. Removable media mounting & virtual filesystems (USB, MTP, Trash)
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # 3. Command-line drive diagnostics (smartctl)
  environment.systemPackages = with pkgs; [
    smartmontools
  ];
}
