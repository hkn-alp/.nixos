{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Messaging & Communication
    signal-desktop

    # Media Streaming
    spotify
  ];
}
