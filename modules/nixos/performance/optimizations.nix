{
  config,
  lib,
  pkgs,
  ...
}:

{
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  hardware.cpu.intel.updateMicrocode = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
    priority = 100;
  };

  services.thermald.enable = true;

  hardware.enableRedistributableFirmware = true;

  environment.sessionVariables = {
    "__GL_SHADER_DISK_CACHE" = "1";
    "__GL_SHADER_DISK_CACHE_PATH" = "/tmp/nvidia-shader-cache";
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };
}
