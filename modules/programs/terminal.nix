{ pkgs, ... }: {
  # --- Dynamic Binary Execution ---
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ stdenv.cc.cc.lib ] ++ (pkgs.appimageTools.defaultFhsEnvArgs.multiPkgs pkgs);
  };

  # --- DirEnv ---
  programs.direnv.enable = true;

  # --- Terminal Environment ---
  environment.systemPackages = with pkgs; [
    kitty
    direnv
    yazi    # Blistering fast terminal file manager
    helix   # Post-modern modal terminal editor
  ];
}
