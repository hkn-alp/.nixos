{ pkgs, ... }: {

  # Force 90Hz kernel mode for the built-in panel
  boot.kernelParams = [ "video=eDP-1:1920x1080@90" ];

  # Automate refresh rate based on power state
  services.udev.extraRules = ''
    # Unplugged: 60Hz
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${pkgs.util-linux}/bin/runuser -u hakanalp -- env WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --mode 1920x1080@60"

    # Plugged in: 90Hz
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${pkgs.util-linux}/bin/runuser -u hakanalp -- env WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --mode 1920x1080@90"
  '';
}
