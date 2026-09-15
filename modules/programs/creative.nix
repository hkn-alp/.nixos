{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Blender
    (pkgs.gpuWrap blender)

    # Video Editor
    (pkgs.gpuWrap davinci-resolve)

    # Image Creation & Manipulation
    lorien
    pinta
    gimp
    inkscape

    # Sound
    audacity

    # Recording & Streaming
    obs-studio
  ];
}
