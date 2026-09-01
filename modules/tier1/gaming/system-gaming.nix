{ config, pkgs, lib, ... }: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        inhibit_screensaver = 0;
      };
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    enableWsi = true;
  };

  systemd.settings.Manager = {
    DefaultLimitNOFILE = "524288";
  };
  security.pam.loginLimits = [
    {
      domain = "hakanalp";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  services.udev.extraRules = ''
    # 8BitDo Ultimate Controller
    SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="3106", MODE="0660", GROUP="input"
    # Universal rule for generic gaming HID pads
    KERNEL=="hidraw*", ATTRS{idVendor}=="2dc8", MODE="0660", GROUP="input"
  '';

  nixpkgs.overlays = [
    (final: prev: {
      steam-run = (prev.steam.override {
        extraLibraries = pkgs': with pkgs'; [
          libxkbcommon
          mesa
          wayland
          (sndio.overrideAttrs (old: {
            postFixup = (old.postFixup or "") + ''
              ln -s $out/lib/libsndio.so $out/lib/libsndio.so.6.1
            '';
          }))
        ];
      }).run;
    })
  ];

  environment.systemPackages = with pkgs; [
    steam-run
    protonup-qt
    mangohud
  ];
}
