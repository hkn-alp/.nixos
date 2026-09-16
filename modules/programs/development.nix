{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    zed-editor-fhs # Zed Editor
    (pkgs.gpuWrap freecad) # FreeCAD
    (pkgs.gpuWrap paraview) # Paraview Visualizer
  ];
}
