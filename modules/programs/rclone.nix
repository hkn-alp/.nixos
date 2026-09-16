# =====================================================================
# DEPLOYMENT DISCLAIMER FOR NEW MACHINES
# =====================================================================
# The automated sync timer will silently skip itself on a new machine
# until you complete the following two manual steps:
#
# 1. Authenticate Rclone:
#    Run `rclone config` to set up the 'gdrive' remote (or securely
#    copy your existing ~/.config/rclone/rclone.conf).
#
# 2. Run the Initial Resync:
#    Rclone needs to build a baseline state file before automation starts.
#    Run this exact command manually one time:
#    rclone bisync "gdrive:/Main" ~/gdrive-main --resync --drive-skip-gdocs --drive-skip-shortcuts --verbose
#
# Once completed, this systemd timer will seamlessly take over.
# =====================================================================

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    rclone # TUI File & Cloud Sync Program
  ];

  # Background service for two-way Google Drive syncing (Main folder)
  systemd.user.services.rclone-bisync = {
    description = "Rclone Bisync for Google Drive (Main Folder)";
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";

      # Silently abort the sync if the rclone configuration file does not exist yet
      ExecCondition = "${pkgs.bash}/bin/bash -c 'test -f %h/.config/rclone/rclone.conf'";

      # Ensure the local gdrive-main directory exists before attempting to sync
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/gdrive-main";

      # The main sync command with auto-recovery and conflict resolution flags added
      ExecStart = "${pkgs.rclone}/bin/rclone bisync 'gdrive:/Main' %h/gdrive-main " +
                  "--resilient " +
                  "--recover " +
                  "--max-lock 2m " +
                  "--conflict-resolve newer " +
                  "--drive-skip-gdocs " +
                  "--drive-skip-shortcuts " +
                  "--verbose";

      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  # Timer to trigger the sync service every 5 minutes
  systemd.user.timers.rclone-bisync = {
    description = "Timer for Rclone Bisync Google Drive (Main Folder)";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*:0/05";
      Persistent = true; # Catches up if the laptop was asleep during a scheduled run
    };
  };
}
