{ ... }: {

  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svnCASPER*:pnEXCALIBUR*:*
     KEYBOARD_KEY_e011=f13
  '';
}
