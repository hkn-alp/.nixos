{ config, pkgs, ... }: {
  users.users.hakanalp = {
    isNormalUser = true;
    description = "Hakan Alparslan";
    initialPassword = "1234";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "docker"
      "dialout"
      "gamemode"
    ];
  };
}
