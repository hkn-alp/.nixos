{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf
    dejavu_fonts
    corefonts
    nerd-fonts.jetbrains-mono
  ];
}
