{ config, pkgs, lib, ... }:

let
  # локальний пакет — повинен повертати derivation (callPackage)
  pppwn = pkgs.callPackage /etc/nixos/mypkgs/pppwn.nix { };
in
{
  options.services.pppwn = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the PPPwn service";
    };

    # Змінено значення за замовчуванням відповідно до твоєї команди
    interface = lib.mkOption {
      type = lib.types.str;
      default = "end0";
      description = "Network interface to use (pppwn -i)";
    };

    fw = lib.mkOption {
      type = lib.types.int;
      default = 1050;
      description = "Firmware version (--fw)";
    };

    stage1 = lib.mkOption {
      type = lib.types.path;
      default = "/pppwn/stage1/stage1.bin";
      description = "Path to stage1 payload (--stage1)";
    };

    stage2 = lib.mkOption {
      type = lib.types.path;
      default = "/pppwn/stage1/stage2.bin";
      description = "Path to stage2 payload (--stage2)";
    };

    # Інші опції залишаються доступними, але за замовчуванням вимкнені/нулі
    timeout = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Timeout in seconds (--timeout / -t), 0 = wait forever";
    };

    waitAfterPin = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Wait-after-pin seconds (-wap)";
    };

    groomDelay = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Heap grooming delay (-gd)";
    };

    bufferSize = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "PCAP buffer size in bytes (-bs), 0 = default";
    };

    autoRetry = lib.mkOption {
      type = lib.types.bool;
      default = true; # ти просив -a за замовчуванням
      description = "Automatically retry when fails (-a / --auto-retry)";
    };

    noWaitPadi = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Don't wait extra PADI (--no-wait-padi)";
    };

    realSleep = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use CPU for more precise sleep (--real-sleep)";
    };

    oldIpv6 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use old IPv6 address (--old-ipv6)";
    };

    web = lib.mkOption {
      type = lib.types.bool;
      default = false; # вимкнено за замовчуванням
      description = "Enable web interface (--web)";
    };

    url = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0:7796";
      description = "URL for web interface (--url)";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional CLI args appended to the pppwn invocation";
    };

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User to run the service as (null means root)";
    };

    ambientCapabilities = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "CAP_NET_RAW" "CAP_NET_ADMIN" ];
      description = "Ambient capabilities for non-root execution";
    };
  };

  config = lib.mkIf config.services.pppwn.enable {
    environment.systemPackages = [ pppwn ];

    systemd.services.pppwn = let
      # Будуємо тільки мінімальні прапорці за замовчуванням
      extra = lib.concatStringsSep " " config.services.pppwn.extraArgs;
      autoRetryFlag = if config.services.pppwn.autoRetry then "--auto-retry" else "";
    in
    {
      description = "PPPwn service (pppwn_cpp)";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = (lib.optionalAttrs (config.services.pppwn.user != null) {
        User = config.services.pppwn.user;
      }) // {
        Type = "simple";
        ExecStart = ''
          ${pppwn}/bin/pppwn \
            -i ${config.services.pppwn.interface} \
            --fw ${toString config.services.pppwn.fw} \
            --stage1 ${config.services.pppwn.stage1} \
            --stage2 ${config.services.pppwn.stage2} \
            ${autoRetryFlag} \
            ${extra}
        '';
        Restart = "on-failure";
        RestartSec = "5s";
        AmbientCapabilities = lib.concatStringsSep " " config.services.pppwn.ambientCapabilities;
      };
    };
  };
}
