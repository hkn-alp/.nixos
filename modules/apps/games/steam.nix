# modules/apps/games/steam.nix
{ ... }: {
  flake.modules.apps.games.steam = { pkgs, lib, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "steam-original"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extest.enable = true; # Fixes controller virtual cursor navigation
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = with pkgs; [
        hidapi
        libXcursor
        libXi
        libXinerama
        libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };
}
