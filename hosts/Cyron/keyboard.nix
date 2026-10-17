{ pkgs, ... }: {

  # Map Casper Excalibur Wi-Fi key (e011) to F13 (183) on boot
  systemd.services.map-wifi-key = {
    description = "Map custom Wi-Fi key to F13";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kbd}/bin/setkeycodes e011 183";
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ]; # Applies to all attached keyboards
        settings = {
          main = {
            "102nd" = "rightcontrol";
          };
        };
      };
    };
  };
  
  environment.variables = {
    XKB_DEFAULT_OPTIONS = "compose:rctrl";
  };
}
