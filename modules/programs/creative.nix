{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (pkgs.gpuWrap blender) # Blender with GPU wrapper
    # (pkgs.gpuWrap davinci-resolve) # DaVinci Resolve with GPU wrapper
    lorien # Infinite Canvas Note Taking App
    gimp # GNU Image Manipulation Program
    inkscape # Vector Image
    obs-studio # Screencasting & Live Streaming Software
  ];
}
