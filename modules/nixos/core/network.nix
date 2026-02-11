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
      allowedTCPPorts = [ 22 ];
    };

    nftables.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;
}
