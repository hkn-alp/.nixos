{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (pkgs.gpuWrap blender) # Blender with GPU wrapper
    # (pkgs.gpuWrap davinci-resolve) # DaVinci Resolve with GPU wrapper
    photocraft
    (pkgs.gpuWrap vectorcraft)
    pdfcraft
    wordcraft
    deckcraft
    gridcraft
  ];
}
