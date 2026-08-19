# modules/hosts/Cyron/nvidia.nix
{ ... }: {
  flake.nixosModules.cyronNvidia = { pkgs, lib, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;
      
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true; 
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
