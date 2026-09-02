{ pkgs, inputs, ... }: 
{
  # --- Noctalia Shell ---
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
  };

  # --- Noctalia Greeter ---
  services.displayManager.noctalia-greeter.enable = true;

  # --- Umbriel Window Manager ---
  programs.umbriel.enable = true;

  # Xwayland outside your Wayland compositor
  environment.systemPackages = [ 
    pkgs.xwayland-satellite 
  ];
}
