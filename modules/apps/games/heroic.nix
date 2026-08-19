# modules/apps/games/heroic.nix
{ ... }: {
  flake.nixosModules.apps.games.heroic = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.heroic.override {
        extraPkgs = pkgs': with pkgs'; [
          gamescope
          gamemode
        ];
      })
    ];
  };
}
