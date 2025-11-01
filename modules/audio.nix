{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    description = lib.mkOption {
      type = lib.types.str;
      default = "Audio module for managing audio settings and devices";
    };
  };

  config = {
    # Увімкнути PipeWire (сучасна система аудіо)
    services.pipewire = {
      enable = lib.mkForce true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable =  true;
    };

    hardware.alsa.enable = true;
    services.pulseaudio.enable = false;    


    # Додаткові пакети для роботи з аудіо
    environment.systemPackages = with pkgs; [
      pwvucontrol # GUI для керування гучністю
      alsa-utils # ALSA утиліти
      pamixer # CLI для PulseAudio/PipeWire
      easyeffects
      calf
    ];

    # Loopback мікрофона
    # щоб звук з мікрофона відтворювався на динаміках
    systemd.user.services.mic-loopback = {
      description = "PipeWire Microphone → Speakers loopback";
      after = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = ''
        ${pkgs.pipewire}/bin/pw-loopback \
          --capture-props="node.name=MicLoopIn" \
          --playback-props="node.name=MicLoopOut"
      '';
      serviceConfig.Restart = "always";
    };
  };
}
