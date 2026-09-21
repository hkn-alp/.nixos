{ pkgs, ... }: {
  # --- Terminal Emulator ---
  environment.systemPackages = [ pkgs.kitty ];

  # --- JetBrains Mono Nerd Font ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # --- System-wide deployment of Kitty configuration
  environment.etc."xdg/kitty/kitty.conf".text = ''
    # Font
    font_family JetBrainsMono Nerd Font
    bold_font auto
    italic_font auto
    bold_italic_font auto
    font_size 11.0

    # Window
    window_padding_width 12
    confirm_os_window_close 0
    background_opacity 0.75
    background_blur 1
  '';
}
