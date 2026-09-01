{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      glib
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXt
      libGL
      freetype
    ];
  };
}
