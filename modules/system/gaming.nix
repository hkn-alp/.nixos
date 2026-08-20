# modules/system/gaming.nix
{ config, pkgs, lib, ... }: {
  
  # === 1. UNFREE PERMISSION FOR STEAM-RUN ===
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam-run"
  ];

  # === 2. GRAPHICS & 32-BIT SUPPORT ===
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # === 3. GAMEMODE & PERFORMANCE ===
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        inhibit_screensaver = 0;
      };
    };
  };

  # === 4. GAMESCOPE COMPOSITOR ===
  programs.gamescope = {
    enable = true;
    capSysNice = true;
    enableWsi = true;
  };

  # === 5. ESYNC & SYSTEMD FILE DESCRIPTOR LIMITS ===
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

  # === 6. CONTROLLER UDEV RULES ===
  services.udev.extraRules = ''
    # 8BitDo Ultimate Controller
    SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="3106", MODE="0660", GROUP="input"
    # Universal rule for generic gaming HID pads
    KERNEL=="hidraw*", ATTRS{idVendor}=="2dc8", MODE="0660", GROUP="input"
  '';

  # === 7. OVERLAYS & STEAM-RUN COMPATIBILITY ===
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
            ''
          }))
        ];
      }).run;
    })
  ];

  # === 8. UTILITIES & EMULATORS ===
  environment.systemPackages = with pkgs; [
    steam-run
    protonup-qt
    mangohud
    
    # RetroArch with bundled cores
    (retroarch.override {
      cores = with libretro; [
        puae
        scummvm
        dosbox
      ];
    })
  ];
}
