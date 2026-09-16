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
      "com.github.tchx84.Flatseal"
      "io.github.flattool.Warehouse"
      "org.onlyoffice.desktopeditors"
      # "com.ranfdev.DistroShelf"
    ];
  };
}
