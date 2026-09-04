{ pkgs, inputs, ... }:
{
  # Flake Inputs
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
    inputs.umbriel.nixosModules.default
  ];

  # --- Noctalia Shell ---
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
  };

  # --- Noctalia Greeter ---
  services.displayManager.noctalia-greeter = {
    enable = true;
    extraArgs = [ "session" "umbriel" ];
  };

  # --- Umbriel Window Manager ---
  programs.umbriel.enable = true;

  # Force Software Rendering and Qt Theme Engine Runtime Variables
  environment.variables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # --- GTK Theming ---
  programs.dconf.enable = true;

  # --- Qt & Kvantum Theming ---
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # --- XDG Desktop Portal (Flatpak Integration) ---
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # Combined System Packages
  environment.systemPackages = with pkgs; [
    # Core & Shell
    xwayland-satellite

    # GTK Theme Engines, Icons & Tools
    adw-gtk3
    papirus-icon-theme
    papirus-folders

    # Qt Theme Engines & Configuration Tools
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          icon-theme = "Papirus-Dark";
        };
      };
    }
  ];
}
