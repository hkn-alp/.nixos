# rclone.nix
#
# =====================================================================
# DEPLOYMENT DISCLAIMER FOR NEW MACHINES
# =====================================================================
# This automated mount will silently skip itself on a new machine
# until you complete the following manual step:
#
# Authenticate Rclone:
#   Run `rclone config` to set up the 'gdrive' remote (or securely
#   copy your existing ~/.config/rclone/rclone.conf).
# =====================================================================

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    rclone # TUI File & Cloud Sync Program
  ];

  # Mount Google Drive virtually (On-Demand Sync for Main folder)
  systemd.user.services.rclone-gdrive-mount = {
    description = "Rclone Virtual Mount for Google Drive (Main Folder)";

    serviceConfig = {
      # Rclone mount supports systemd's 'notify' type natively
      Type = "notify";

      # Tell systemd to NEVER give up restarting the service
      # (crucial for waiting on slow Wi-Fi connections during boot)
      StartLimitIntervalSec = "0";

      # Silently skip if not authenticated yet
      ExecCondition = "${pkgs.bash}/bin/bash -c 'test -f %h/.config/rclone/rclone.conf'";

      # Ensure the mount point exists
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/gdrive-main";

      # The mount command with VFS caching enabled.
      ExecStart = "${pkgs.rclone}/bin/rclone mount 'gdrive:/Main' %h/gdrive-main " +
                  "--vfs-cache-mode full " +
                  "--vfs-cache-max-age 24h " +
                  "--vfs-cache-max-size 20G";

      # Cleanly unmount when the service stops or restarts
      ExecStop = "/run/wrappers/bin/fusermount -u %h/gdrive-main";

      # Automatically restart if the network drops or it crashes
      Restart = "always";
      RestartSec = "10s";
    };

    # Start automatically when you log into your desktop
    wantedBy = [ "default.target" ];
  };
}
