{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # onlyoffice-desktopeditors # It is behind
    joplin-desktop
    texstudio
    papers
    simple-scan
  ];
}
