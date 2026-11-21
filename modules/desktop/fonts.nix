{ config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      dejavu_fonts
      corefonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
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

  # GTK & GNOME Interface Settings
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          font-name = "Noto Sans 11";
          document-font-name = "Noto Sans 11";
          monospace-font-name = "JetBrainsMono Nerd Font 11";
        };
      };
    }
  ];
}
