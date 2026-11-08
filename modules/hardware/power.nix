# Location: modules/hardware/power.nix
{ lib, ... }: {
  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  powerManagement = {
    powertop.enable = true;
    cpuFreqGovernor = lib.mkForce ""; 
  };

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 20;
      STOP_CHARGE_THRESH_BAT0 = 85;

      # Keep TLP CPU management disabled so auto-cpufreq rules take effect
      CPU_SCALING_ON_AC = "";
      CPU_SCALING_ON_BAT = "";
      CPU_ENERGY_PERF_POLICY_ON_AC = "";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "";
      PLATFORM_PROFILE_ON_AC = "";
      PLATFORM_PROFILE_ON_BAT = "";
    };
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
        energy_perf_bias = "power"; # Maximum energy saving on battery
      };
      charger = {
        governor = "performance";
        turbo = "auto";
        energy_perf_bias = "performance"; # Maximum performance on charger (0)
      };
    };
  };
}
