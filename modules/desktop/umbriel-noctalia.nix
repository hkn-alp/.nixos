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
    platformTheme = "gnome";
    style = "adwaita-dark";
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

    # GTK Theme Engines
    adw-gtk3

    # Papirus Icon Theme
    # https://github.com/PapirusDevelopmentTeam/papirus-folders
    # (papirus-icon-theme.override {
    #   color = "yaru";
    # })

    # https://github.com/catppuccin/papirus-folders
    # (catppuccin-papirus-folders.override {
    #   flavor = "frappe";
    #   accent = "maroon";
    # })

    # https://github.com/Adapta-Projects/Papirus-Nord
    (papirus-nord.override {
      accent = "polarnight3";
    })

    # Qt Theme Engines
    adwaita-qt
    adwaita-qt6
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
          icon-theme = "Papirus-Dark";
        };
      };
    }
  ];
}
