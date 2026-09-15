{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # CAD & Visualization
    (pkgs.gpuWrap freecad)
    (pkgs.gpuWrap paraview)

    # Editor
    zed-editor-fhs
  ];
}
