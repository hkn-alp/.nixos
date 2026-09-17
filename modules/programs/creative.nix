{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (pkgs.gpuWrap blender) # Blender with GPU wrapper
    # (pkgs.gpuWrap davinci-resolve) # DaVinci Resolve with GPU wrapper
    shotcut # Video Editor
    lorien # Infinite Canvas Note Taking App
    pinta # Painting Made Simple
    gimp # GNU Image Manipulation Program
    inkscape # Vector Image
    audacity # Audio Editor
    obs-studio # Screencasting & Live Streaming Software
  ];
}
