{ lib, inputs, config, pkgs, ... }: {
  home.file.".config/wlogout/style.css".text = ''
    window {
      background-color: rgba(29, 32, 33, 0.95); /* base00 */
    }

    button {
      background-image: none;
      background-color: #3c3836; /* base02 */
      color: #ddc7a1; /* base06 */
      border-radius: 16px;
      border: 2px solid #7c6f64; /* base04 */
      margin: 10px;
      padding: 20px;
    }

    button:focus, button:hover {
      background-color: #434a4c; /* base03 */
      border: 2px solid #d8a657; /* base0A (yellow accent) */
      color: #e78a4e; /* base09 */
    }

    #lock {
      background-image: url("/home/<USER>/.config/wlogout/icons/lock.svg");
    }

    #logout {
      background-image: url("/home/<USER>/.config/wlogout/icons/logout.svg");
    }

    #suspend {
      background-image: url("/home/<USER>/.config/wlogout/icons/suspend.svg");
    }

    #hibernate {
      background-image: url("/home/<USER>/.config/wlogout/icons/hibernate.svg");
    }

    #shutdown {
      background-image: url("/home/<USER>/.config/wlogout/icons/shutdown.svg");
    }

    #reboot {
      background-image: url("/home/<USER>/.config/wlogout/icons/reboot.svg");
    }
  '';
}
