{ pkgs, inputs, ... }:
{
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

  # System Packages
  environment.systemPackages = with pkgs; [
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
