{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.heroic.override {
      extraPkgs = pkgs': with pkgs'; [
        gamescope
        gamemode
      ];
    })
  ];
}
