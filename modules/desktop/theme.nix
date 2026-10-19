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

  # --- System Fonts ---
  fonts = {
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-color-emoji
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Inter" "Noto Sans" ];
        serif = [ "Noto Serif" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
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
          font-name = "Noto Sans 11";
          document-font-name = "Noto Sans 11";
          monospace-font-name = "JetBrainsMono Nerd Font 11";
          cursor-theme = "Bibata-Modern-Classic";
        };
      };
    }
  ];
  systemd.user.services.sync-cursor-theme = {
    description = "Force GTK cursor settings synchronization for Umbriel";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = ''
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-size 24
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
