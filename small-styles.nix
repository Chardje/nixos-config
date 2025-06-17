{ lib, inputs, config, pkgs, ... }:
{
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
    background-color: #6c782e; /* base0D (dark green) */
  }

  #logout {
    background-color: #ea6962; /* base0E (magenta) */
  }

  #suspend {
    background-color: #89b482; /* base0C (cyan) */
  }

  #hibernate {
    background-color: #a9b665; /* base0B (green) */
  }

  #reboot {
    background-color: #d8a657; /* base0A (yellow) */
  }

  #shutdown {
    background-color: #c14a4a; /* base08 (red) */
  }
'';
}