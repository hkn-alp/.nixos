{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (pkgs.gpuWrap blender)
    # (pkgs.gpuWrap davinci-resolve)
    lorien
    pinta
    gimp
    inkscape
    audacity
    obs-studio
  ];
}
