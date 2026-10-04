{ pkgs, ... }:
{
  # --- Noctalia Shell ---
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
  };

  # --- Noctalia Greeter ---
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = [ "hakanalp" ];
  };

  systemd.user.services.noctalia-sleep-lock = {
    description = "Sleep inhibitor for noctalia-greeter";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      # The -w flag is the magic here. It waits for the locker to map to the screen.
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w before-sleep 'noctalia-greeter & ${pkgs.coreutils}/bin/sleep 1.5'";
      Restart = "always";
      # Force the Wayland socket so the systemd service can talk to Umbriel
      Environment = [
        "WAYLAND_DISPLAY=wayland-0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  # --- Umbriel Window Manager ---
  programs.umbriel.enable = true;

  # Force Software Rendering and Qt Theme Engine Runtime Variables
  environment.variables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  # Keyring
  services.gnome.gnome-keyring.enable = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    wl-clipboard
    xwayland-satellite
    seahorse
  ];
}
