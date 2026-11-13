# Location: modules/hardware/power.nix
{ lib, ... }: {
  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkForce null;
  systemd.services.cpufreq.enable = false;

  # TLP is disabled because software charge thresholds are unsupported by this hardware ACPI
  services.tlp.enable = false;

  # auto-cpufreq handles dynamic CPU performance and power saving modes seamlessly
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
        energy_perf_bias = "power";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
        energy_perf_bias = "performance";
      };
    };
  };
}
