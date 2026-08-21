{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.lutris.override {
      extraLibraries = pkgs': with pkgs'; [
        libxkbcommon
        mesa
        wayland
      ];
      extraPkgs = pkgs': with pkgs'; [
        gamescope
        gamemode
        wineWowPackages.stable
        winetricks
      ];
    })
  ];
}
