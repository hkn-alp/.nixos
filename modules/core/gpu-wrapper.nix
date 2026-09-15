{ config, pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      gpuWrap = pkg:
        # Check if the host has PRIME offload explicitly enabled
        if (config.hardware.nvidia.prime.offload.enable or false) then
          prev.symlinkJoin {
            name = "${pkg.name}-gpu";
            paths = [ pkg ];
            buildInputs = [ prev.makeWrapper ];
            postBuild = ''
              # Iterate through common executable directories
              for dir in "$out/bin" "$out/libexec"; do
                if [ -d "$dir" ]; then
                  for target in "$dir"/*; do
                    # Only apply wrapProgram if the target is an executable file
                    if [ -f "$target" ] && [ -x "$target" ]; then
                      wrapProgram "$target" \
                        --set __NV_PRIME_RENDER_OFFLOAD 1 \
                        --set __VK_LAYER_NV_optimus NVIDIA_only \
                        --set __GLX_VENDOR_LIBRARY_NAME nvidia
                    fi
                  done
                fi
              done
            '';
          }
        else
          # Fallback: return the application untouched for the VM and Server
          pkg;
    })
  ];
}
