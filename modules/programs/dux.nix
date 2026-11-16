{ config, pkgs, inputs, ... }: {
  
  programs.dux-files = {
    enable = true;
    systemd = {     
      enable = true;
      restartIfChanged = true;
    };
    portal = {
      enable = true;
    };
  };
  
  # Native NixOS portal configuration replacing portal.preferred = true
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.dux-files ];
    config.common = {
      # Sets dux-files as the preferred backend for open/save dialogs
      "org.freedesktop.impl.portal.FileChooser" = [ "dux-files" ];
    };
  };

  environment.systemPackages = [
    pkgs.dux-gop
  ];
}
