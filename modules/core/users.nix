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

  systemd.tmpfiles.rules = [
    "d /home/hakanalp/.cache 0755 hakanalp users -"
    "d /home/hakanalp/.config 0755 hakanalp users -"
    "d /home/hakanalp/.local 0755 hakanalp users -"
    "d /home/hakanalp/.local/share 0755 hakanalp users -"
    "d /home/hakanalp/.var 0755 hakanalp users -"
  ];
}
