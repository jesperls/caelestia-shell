{
  config,
  lib,
  ...
}:

{
  networking = {
    hostName = config.mySystem.system.hostName;

    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };

    firewall = {
      enable = true;
      allowPing = true;
    };

    nftables.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;
}
