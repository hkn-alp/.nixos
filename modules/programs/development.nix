{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    zed-editor-fhs # Zed Editor
    nil # nil language server
    nixd # nixd language server
    (pkgs.gpuWrap freecad) # FreeCAD
    (pkgs.gpuWrap paraview) # Paraview Visualizer
  ];
}
