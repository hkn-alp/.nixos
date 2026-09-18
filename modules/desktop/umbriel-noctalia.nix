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
    passwordless-sync-users = [ "hakanalp" ];
  };

  # --- Umbriel Window Manager ---
  programs.umbriel.enable = true;

  # Force Software Rendering and Qt Theme Engine Runtime Variables
  environment.variables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  # --- GTK Theming ---
  programs.dconf.enable = true;

  # --- Qt Theming ---
  qt = {
    enable = true;
    platformTheme = "qt5ct";
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
    wl-clipboard
    xwayland-satellite

    # GTK Theme Engines, Icons & Tools
    adw-gtk3
    papirus-icon-theme
    papirus-folders

    # Qt Theme Engines
    libsForQt5.qt5ct
    kdePackages.qt6ct
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
