{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let

in
{
  boot.kernelModules = [ "msr" ];
  environment.systemPackages = with pkgs; [
    msr
    intel-undervolt  
    s-tui
    stress
  ];
  systemd.services.intel-undervolt = {
    description = "Apply Intel CPU Undervolt";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.intel-undervolt}/bin/intel-undervolt apply";
    };
  };
}
