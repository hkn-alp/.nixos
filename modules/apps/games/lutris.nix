# modules/apps/games/lutris.nix
{ ... }: {
  flake.nixosModules.apps.games.lutris = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.lutris.override {
        extraLibraries = pkgs': with pkgs'; [
          # Extra graphics and system libraries for Wine runners
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
  };
}
