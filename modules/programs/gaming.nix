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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extest.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    extraPackages = with pkgs; [
      hidapi
      libXcursor
      libXi
      libXinerama
      libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ];
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
    mangohud
    # Games
    (pkgs.gpuWrap supertuxkart)
  ];
}
