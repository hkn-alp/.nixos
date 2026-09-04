{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Base compilers & C standard libraries
      stdenv.cc.cc.lib
    ] ++ (pkgs.appimageTools.defaultFhsEnvArgs.multiPkgs pkgs);
  };
}
