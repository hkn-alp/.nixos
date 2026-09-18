{ lib, pkgs, ... }: {
  services.snapper = {
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "hakanalp" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "6";
        TIMELINE_LIMIT_DAILY = "4";
        TIMELINE_LIMIT_WEEKLY = "2";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
      };
    };
  };

  systemd.timers.snapper-timeline.timerConfig = {
    OnCalendar = lib.mkForce "*-*-* 00/3:00:00";
  };
}
