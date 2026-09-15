{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    onlyoffice-desktopeditors
    joplin-desktop
    texstudio
    papers
    simple-scan
  ];
}
