{ pkgs, ... }: {
  # 1. Global Terminal & Shell Variables
  environment.variables = {
    EDITOR = "micro";
    VISUAL = "micro";
    TERMINAL = "kitty";
    BROWSER = "firefox";
  };

  # 2. Graphical MIME Default Associations
  xdg.mime = {
    enable = true;
    defaultApplications = {
      # Directories
      "inode/directory" = "org.gnome.Nautilus.desktop";

      # Plain Text & Source
      "text/plain" = "org.gnome.TextEditor.desktop";

      # Web & Documents
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/pdf" = "org.gnome.Papers.desktop"; # Matches 'papers' in productivity.nix

      # Media
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
      "video/x-matroska" = "io.github.celluloid_player.Celluloid.desktop";
    };
  };
}
