{ inputs, ... }: {
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    # Force strict declarative mode: wipe any imperative CLI installs on rebuild
    uninstallUnmanaged = true;

    update = {
      onActivation = true;
      auto = {
        enable = true;
        onCalendar = "daily";
      };
    };

    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      # Add Flatpaks here. Anything not in this list gets deleted.

      # Flatpak Utilities
      "com.github.tchx84.Flatseal"
      "io.github.flattool.Warehouse"

      # Desktop Apps
      "org.onlyoffice.desktopeditors"
      "net.cozic.joplin_desktop"

      # Distrobox Utilities
      # "com.ranfdev.DistroShelf"

      # Engineering Tools
      "org.freecadweb.FreeCAD"
      "org.paraview.ParaView"
    ];

    # Overrides
    overrides = {
      "org.freecadweb.FreeCAD".Environment = {
        "__NV_PRIME_RENDER_OFFLOAD" = "1";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        "__VK_LAYER_NV_optimus" = "NVIDIA_only";
      };

      "org.paraview.ParaView".Environment = {
        "__NV_PRIME_RENDER_OFFLOAD" = "1";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        "__VK_LAYER_NV_optimus" = "NVIDIA_only";
      };
    };
  };
}
