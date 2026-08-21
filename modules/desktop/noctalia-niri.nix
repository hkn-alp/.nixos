{ config, pkgs, lib, inputs, ... }: 
let
  noctalia-niri-pkg = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
    inherit pkgs;
    settings = (builtins.fromTOML (builtins.readFile ../config/noctalia-niri/noctalia-config.toml)).settings;
  };

  niri4noctalia-pkg = inputs.wrapper-modules.wrappers.niri.wrap {
    inherit pkgs;
    settings = {
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
    };
    extraConfig = builtins.readFile ../config/noctalia-niri/niri-config.kdl;
  };
in 
{
  imports = [ 
    inputs.noctalia.nixosModules.default 
    inputs.noctalia-greeter.nixosModules.default
  ];
  
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
    package = noctalia-niri-pkg;
  };
  
  programs.noctalia-greeter = {
    enable = true;
    greeter-args = "session niri";
  };

  programs.niri = {
    enable = true;
    package = niri4noctalia-pkg;
  };
}
