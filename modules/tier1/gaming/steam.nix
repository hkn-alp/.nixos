{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extest.enable = true;
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
}
