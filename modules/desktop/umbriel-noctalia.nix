{ pkgs, inputs, ... }:
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
