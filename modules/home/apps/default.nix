{ ... }:

{
  # The Master App Hub
  # This file simply acts as a bridge to subfolders.
  # Comment out any category to instantly uninstall all apps inside it.
  
  imports = [
    ./browsers
    ./communications
    ./development
    ./games
    ./media
    ./office
    ./scientific
    ./system-tools
    ./terminals
  ];
}
