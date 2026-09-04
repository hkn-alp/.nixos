{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    unzip
    ripgrep
    jq
    btop
    pciutils
    usbutils
    wl-clipboard
    gnome-disk-utility
    micro-full
    yazi
  ];
}
