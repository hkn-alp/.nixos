{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-sound-recorder
  ];
}
