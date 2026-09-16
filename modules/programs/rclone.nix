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
# 2. Run the Mount:
#    Run this exact command manually one time:
#    rclone mount "gdrive:/Main" ~/gdrive-main --vfs-cache-mode full --vfs-cache-max-age 24h --vfs-cache-max-size 20G --daemon
# =====================================================================

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    rclone # TUI File & Cloud Sync Program
  ];
}
