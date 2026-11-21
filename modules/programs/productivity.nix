{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    joplin-desktop
    papers
    simple-scan
  ];
}
