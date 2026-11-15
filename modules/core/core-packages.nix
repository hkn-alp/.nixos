{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    unzip
    ripgrep
    pciutils
    usbutils
  ];
}
