{ pkgs, ... }: {
  # 1. Background SMART daemon & desktop notifications
  services.smartd = {
    enable = true;
    notifications.systembus-notify.enable = true;
  };

  # 2. Command-line drive diagnostics (smartctl)
  environment.systemPackages = with pkgs; [
    smartmontools
  ];
}
