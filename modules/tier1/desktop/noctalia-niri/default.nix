{ pkgs, lib, inputs, ... }: 
{
  # --- Noctalia Shell ---
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
    package = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      
      settings = lib.recursiveUpdate 
        (builtins.fromTOML (builtins.readFile ./noctalia-config.toml)) 
        {
          wallpaper.default.path = "${../../../../assets/wallpapers/Mostar.jpg}";
        };
    };
  };

  # --- Noctalia Greeter ---
  services.displayManager.noctalia-greeter = {
    enable = true;
    extraArgs = [ "session" "niri" ];
  };

  # --- Niri Window Manager (Upstream NixOS Method) ---
  programs.niri.enable = true;

  # Route your raw KDL file into the system configuration directory
  environment.etc."niri/config.kdl".source = ./niri-config.kdl;
  
  # Tell Niri exactly where to find it
  environment.variables.NIRI_CONFIG = "/etc/niri/config.kdl";

  # --- Wiki Recommended Fixes ---
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  environment.systemPackages = [ 
    pkgs.xwayland-satellite 
  ];
}
