{ config, pkgs, lib, ... }: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver # Modern Intel iGPUs
      intel-vaapi-driver # Older Intel iGPUs (fallback)
      libvdpau-va-gl
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = false;

    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
