{ config, ... }: {
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ]; # This will scrub your entire cryptroot
  };
}
