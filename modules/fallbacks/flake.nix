{
  description = "Global Tier 3 Development Environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # ==========================================
    # 1. PYTHON PACKAGE LISTS (The building blocks)
    # ==========================================
    basePyPkgs = ps: with ps; [ numpy scipy matplotlib pandas spiceypy ];
    jupyterPkgs = ps: with ps; [ jupyter ];

    # ==========================================
    # 2. TOOLCHAIN VARIABLES
    # ==========================================
    
    # Pure Python
    pythonToolchain = [
      (pkgs.python3.withPackages basePyPkgs)
      pkgs.python3Packages.python-lsp-server
    ];

    # Python + Jupyter (Merging the package lists dynamically!)
    jupyterToolchain = [
      (pkgs.python3.withPackages (ps: basePyPkgs ps ++ jupyterPkgs ps))
      pkgs.python3Packages.python-lsp-server
    ];

    # Julia Core
    juliaToolchain = [ pkgs.julia-bin ];

    # Rust Core
    rustToolchain = with pkgs; [ cargo rustc rustfmt clippy rust-analyzer ];

    # LaTeX Core
    texToolchain = with pkgs; [ texlive.combined.scheme-full texlab ];

    # C/C++ Core
    cToolchain = with pkgs; [ gcc gdb cmake clang-tools ];

  in {
    devShells.${system} = {
      
      # ==========================================
      # 3. INDIVIDUAL SHELLS
      # ==========================================
      python = pkgs.mkShell { packages = pythonToolchain; };
      jupyter = pkgs.mkShell { packages = jupyterToolchain; };
      rust = pkgs.mkShell { packages = rustToolchain; };
      latex = pkgs.mkShell { packages = texToolchain; };
      c-cpp = pkgs.mkShell { packages = cToolchain; };
      julia = pkgs.mkShell { packages = juliaToolchain; };

      # ==========================================
      # 4. COMBINED SHELLS
      # ==========================================
      
      # The Ultimate Astrodynamics Shell (Jupyter + Python + Julia)
      jupyter-julia = pkgs.mkShell {
        packages = jupyterToolchain ++ juliaToolchain;
        
        # This hook runs automatically when you type 'direnv allow'
        shellHook = ''
          # Force Julia to install packages into the local project folder
          # instead of the global ~/.julia directory
          export JULIA_PROJECT="@."
          
          # Force Jupyter to look for kernels in the local project
          export JUPYTER_DATA_DIR="$PWD/.jupyter"
          
          echo "🚀 Jupyter-Julia Environment Activated!"
          echo "To initialize Julia packages for this specific project:"
          echo "  1. Type 'julia' to enter the REPL."
          echo "  2. Type ']' to enter the Pkg manager."
          echo "  3. Run: add IJulia LinearAlgebra Plots BenchmarkTools WriteVTK"
        '';
      };

    };
  };
}
