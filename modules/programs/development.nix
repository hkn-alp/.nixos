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
    (texliveMedium.withPackages (ps: with ps; [
      # Compilation
      latexmk
      
      # Explicitly declared in your preamble
      graphics       # graphicx
      amsmath
      mhchem
      siunitx
      tools          # bundles longtable, tabularx, multicol, array
      caption        # bundles subcaption
      placeins
      multirow
      geometry
      titlesec
      enumitem
      hyperref
      booktabs
      fontawesome5
      parskip

      # Additional math, colors, and citations
      xcolor
      mathtools
      amsfonts
      biber
      biblatex

      # AIAA Class Dependencies
      newtx
      microtype
      footmisc
      lettrine
      quoting
      natbib
    ]))
  ];
}
