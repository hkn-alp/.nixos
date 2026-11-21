# Location: modules/desktop/theme.nix
{ pkgs, ... }:
{
  # --- GTK Theming ---
  programs.dconf.enable = true;

  # --- Qt Theming ---
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # --- XDG Desktop Portal ---
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    adw-gtk3
    (papirus-nord.override {
      accent = "polarnight3";
    })
    adwaita-qt
    adwaita-qt6
    bibata-cursors
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # GTK & GNOME Interface Settings
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
          icon-theme = "Papirus-Dark";
          cursor-theme = "Bibata-Modern-Classic";
        };
      };
    }
  ];
}
