{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.writeTextDir "share/mime/packages/simulink.xml" ''
      <?xml version="1.0" encoding="UTF-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="application/vnd.mathworks.simulink.model">
          <comment>Simulink model</comment>
          <sub-class-of type="application/zip"/>
          <glob pattern="*.slx" weight="80"/>
        </mime-type>
      </mime-info>
    '')
  ];
}
