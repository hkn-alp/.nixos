{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    zed-editor-fhs # Zed Editor
    nil # nil language server
    nixd # nixd language server
    (pkgs.gpuWrap freecad) # FreeCAD
    (pkgs.gpuWrap paraview) # Paraview Visualizer
    
    # --- Python & Jupyter ---
    (python3.withPackages (ps: with ps; [
      jupyterlab
      ipykernel
      numpy
      scipy
      matplotlib
      pandas
    ]))

    # --- Julia ---
    julia-bin

    # --- C/C++ Toolchain ---
    gcc
    clang
    gdb
    gnumake
    cmake

    # --- LaTeX ---
    # --- LaTeX ---
    texstudio
    texliveFull
  ];
}
