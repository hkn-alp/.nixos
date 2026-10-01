{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # onlyoffice-desktopeditors # It is behind
    # joplin-desktop # It has dependency problems
    texstudio
    papers
    simple-scan
  ];
}
