{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (gpuWrap blender) # Blender with GPU wrapper
    lorien # Infinite Canvas Note Taking App
    gimp # GNU Image Manipulation Program
    inkscape # Vector Image
    obs-studio # Screencasting & Live Streaming Software
    
    # Artcraft Suite
    photocraft
    (gpuWrap vectorcraft)
    pdfcraft
    wordcraft
    deckcraft
    gridcraft
  ];
}
