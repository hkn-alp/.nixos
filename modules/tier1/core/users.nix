{ config, lib, pkgs, ... }: {
  users.users.hakanalp = {
    isNormalUser = true;
    description = "Hakan Alparslan";
    initialPassword = "1234";
    extraGroups = [
      "wheel" 
      "input" 
    ] ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      ++ lib.optional config.virtualisation.docker.enable "docker"
      ++ lib.optional config.programs.gamemode.enable "gamemode";
  };
}
