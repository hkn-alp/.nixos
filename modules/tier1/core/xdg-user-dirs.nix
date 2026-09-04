{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.xdg-user-dirs ];

  systemd.user.services.xdg-user-dirs-update = {
    description = "Update XDG user directory configuration";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update";
      Type = "oneshot";
    };
  };
}
