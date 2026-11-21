{ pkgs, ... }: {
  # Dynamic Binary Execution
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ stdenv.cc.cc.lib ] ++ (pkgs.appimageTools.defaultFhsEnvArgs.multiPkgs pkgs);
  };

  # DirEnv
  programs.direnv.enable = true;
  
  environment.systemPackages = with pkgs; [
    zed-editor-fhs # Zed Editor
    (pkgs.gpuWrap freecad) # FreeCAD
    (pkgs.gpuWrap paraview) # Paraview Visualizer
    texstudio # LaTeX IDE
    
    # Language Servers
    nil # nil language server
    nixd # nixd language server
    
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
    texliveFull
  ];
}
