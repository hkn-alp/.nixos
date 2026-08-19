{ ... }: {
  flake.nixosModules.apps.games.supertuxkart = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.symlinkJoin {
        name = "supertuxkart-nvidia";
        paths = [ pkgs.supertuxkart ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/supertuxkart \
            --set __NV_PRIME_RENDER_OFFLOAD 1 \
            --set __VK_LAYER_NV_optimus NVIDIA_only \
            --set __GLX_VENDOR_LIBRARY_NAME nvidia
        '';
      })
    ];
  };
}
