{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mpv
    celluloid
    imv
    loupe
    snapshot
    gnome-sound-recorder
  ];
}
