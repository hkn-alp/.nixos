{ inputs, ... }: {
  
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    update.auto = {
      enable = true;
      onCalendar = "daily";
    };

    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      # --- GNOME Core & Utilities ---
      "org.gnome.Boxes"
      "org.gnome.Firmware"
      "org.gnome.Logs"
      "org.gnome.Loupe"
      "org.gnome.NetworkDisplays" # Miracast App
      "org.gnome.Papers"
      "org.gnome.Showtime"
      "org.gnome.SimpleScan"
      "org.gnome.Snapshot"
      "org.gnome.SoundRecorder"
      "org.gnome.baobab"
      "org.gnome.font-viewer"
      
      # --- System Tools & Customization ---
      "com.github.tchx84.Flatseal"
      "com.ranfdev.DistroShelf"
      "io.github.flattool.Warehouse"
      "io.missioncenter.MissionCenter"
      "io.gitlab.adhami3310.Impression"

      # --- Office & Productivity ---
      "org.onlyoffice.desktopeditors"

      # --- Creative & Media ---
      "org.blender.Blender"
      "org.kde.krita"
      "org.gimp.GIMP"
      "org.inkscape.Inkscape"
      "org.audacityteam.Audacity"
      "org.kde.kdenlive"
      "com.obsproject.Studio"

      # --- Engineering & Science ---
      "org.freecad.FreeCAD"
      "org.paraview.ParaView"

      # --- Gaming ---
      "net.supertuxkart.SuperTuxKart"
      "com.vysp3r.ProtonPlus"
      "com.github.Matoking.protontricks"

      # --- Browsers ---
      "io.gitlab.librewolf-community"
      
      # --- Communictaion ---
      "org.signal.Signal"

      # --- Miscellaneous ---
      "io.github.flattool.Ignition"
      "io.github.kolunmi.Bazaar"
    ];
  };
}
