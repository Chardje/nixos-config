{ config, lib, pkgs, ... }:

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
      pulse.enable = true;
      jack.enable = false; # якщо не потрібен JACK
    };

    hardware.alsa.enable = true;
    services.pulseaudio.enable = false; # PipeWire замінює PulseAudio

    # Додаткові пакети для роботи з аудіо
    environment.systemPackages = with pkgs; [
      pavucontrol   # GUI для керування гучністю
      alsa-utils    # ALSA утиліти
      pamixer       # CLI для PulseAudio/PipeWire
    ];
  };
}