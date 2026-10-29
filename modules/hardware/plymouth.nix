{ pkgs, ... }: {
  boot = {
    # Graphical Boot & LUKS Prompt
    plymouth.enable = true;

    # Silent Boot (Hide Code Flow)
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
