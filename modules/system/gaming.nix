# modules/system/gaming.nix
{ self, inputs, ... }: {
  
  flake.modules.system.gaming = { config, pkgs, lib, ... }: {

    # === 1. GRAPHICS & 32-BIT SUPPORT ===
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # === 2. GAMEMODE & PERFORMANCE ===
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          inhibit_screensaver = 0;
        };
      };
    };

    # === 3. GAMESCOPE COMPOSITOR ===
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      enableWsi = true;
    };

    # === 4. ESYNC & SYSTEMD FILE DESCRIPTOR LIMITS ===
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

    # === 5. CONTROLLER UDEV RULES ===
    services.udev.extraRules = ''
      # 8BitDo Ultimate Controller
      SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="3106", MODE="0660", GROUP="input"
      # Universal rule for generic gaming HID pads
      KERNEL=="hidraw*", ATTRS{idVendor}=="2dc8", MODE="0660", GROUP="input"
    '';

    # === 6. OVERLAYS & STEAM-RUN COMPATIBILITY ===
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

    # === 7. UTILITIES & EMULATORS ===
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
  };
}
