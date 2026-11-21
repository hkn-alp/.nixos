{ pkgs, ... }: {
  # XDG User Directories Update Service
  systemd.user.services.xdg-user-dirs-update = {
    description = "Update XDG user directory configuration";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update";
      Type = "oneshot";
    };
  };
  
  # Global Terminal & Shell Variables
  environment.variables = {
    EDITOR = "micro";
    VISUAL = "micro";
    TERMINAL = "kitty";
    BROWSER = "firefox";
  };
  
  # Graphical MIME Default Associations
  xdg.mime = {
    enable = true;
    defaultApplications = {
      # File Manager
      "inode/directory" = "luciole.desktop";
      
      # Plain Text & Source
      "text/plain" = "org.gnome.TextEditor.desktop";

      # Web & Documents
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/pdf" = "org.gnome.Papers.desktop";

      # Media
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
      "video/x-matroska" = "io.github.celluloid_player.Celluloid.desktop";
    };
  };
  
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
    xdg-terminal-exec
    
    # Mime Definitions
    (writeTextDir "share/mime/packages/simulink.xml" ''
      <?xml version="1.0" encoding="UTF-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="application/vnd.mathworks.simulink.model">
          <comment>Simulink model</comment>
          <sub-class-of type="application/zip"/>
          <glob pattern="*.slx" weight="80"/>
        </mime-type>
      </mime-info>
    '')
  ];
}
