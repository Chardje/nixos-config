{ inputs, pkgs, ... }:
let
  hypr = inputs.hyprland.packages.${pkgs.system};
in
{
  imports = [
    ../modules/mainconfig.nix
  ];
  
  home.file.".config/hypr/rules.conf".text = ''
# ╔══════════════════════════════════════════════════════════════╗
# ║            illogical-impulse rules для Hyprland 0.50+        ║
# ╚══════════════════════════════════════════════════════════════╝

# ── QuickShell (всі панелі, віджети, попапи) ─────────────────────
layerrule = blur, quickshell:.*
layerrule = ignorealpha 0.79, quickshell:.*
layerrule = noanim, quickshell:actionCenter
layerrule = noanim, quickshell:lockWindowPusher
layerrule = noanim, quickshell:overlay
layerrule = noanim, quickshell:overview
layerrule = noanim, quickshell:polkit
layerrule = noanim, quickshell:regionSelector
layerrule = noanim, quickshell:screenshot
layerrule = noanim, quickshell:session
layerrule = noanim, quickshell:wOnScreenDisplay
layerrule = animation slide, quickshell:bar
layerrule = animation slide bottom, quickshell:cheatsheet
layerrule = animation slide bottom, quickshell:dock
layerrule = animation popin 120%, quickshell:screenCorners
layerrule = animation fade, quickshell:notificationPopup
layerrule = animation slide bottom, quickshell:osk
layerrule = animation slide right, quickshell:sidebarRight
layerrule = animation slide left, quickshell:sidebarLeft
layerrule = animation slide, quickshell:verticalBar
layerrule = animation slide top, quickshell:wallpaperSelector
layerrule = xray off, quickshell:popup
layerrule = ignorealpha 1, quickshell:popup
layerrule = ignorealpha 1, quickshell:mediaControls

# ── AGS (якщо ще використовується) ───────────────────────────────
layerrule = blur, bar[0-9]*
layerrule = blur, dock[0-9]*
layerrule = blur, sideleft.*
layerrule = blur, sideright.*
layerrule = ignorealpha 0.6, bar.*
layerrule = ignorealpha 0.6, dock.*
layerrule = ignorealpha 0.6, sideleft.*
layerrule = ignorealpha 0.6, sideright.*
layerrule = animation slide left, sideleft.*
layerrule = animation slide right, sideright.*

# ── Загальні layer-правила (wlogout, anyrun тощо) ─────────────────
layerrule = blur, notifications
layerrule = ignorealpha 0.69, notifications
layerrule = blur, logout_dialog
layerrule = blur, gtk-layer-shell
layerrule = ignorezero, gtk-layer-shell
layerrule = noanim, anyrun
layerrule = noanim, walker
layerrule = noanim, selection
layerrule = noanim, overview
layerrule = noanim, osk
layerrule = noanim, hyprpicker

# ── Window rules (новий синтаксис — windowrule, а не windowrulev2) ──
windowrule = float, title:^(Open File)(.*)$
windowrule = center, title:^(Open File)(.*)$
windowrule = float, title:^(Select a File)(.*)$
windowrule = center, title:^(Select a File)(.*)$
windowrule = float, title:^(Choose wallpaper)(.*)$
windowrule = size 60% 65%, title:^(Choose wallpaper)(.*)$
windowrule = center, title:^(Choose wallpaper)(.*)$

windowrule = float, title:^(Open Folder)(.*)$
windowrule = float, title:^(Save As)(.*)$
windowrule = float, title:^(Library)(.*)$
windowrule = float, title:^(File Upload)(.*)$
windowrule = float, title:^(.*)(wants to save)$
windowrule = float, title:^(.*)(wants to open)$

windowrule = float, class:^(blueberry\.py)$
windowrule = float, class:^(guifetch)$
windowrule = float, class:^(pavucontrol)$
windowrule = size 45%, class:^(pavucontrol)$
windowrule = center, class:^(pavucontrol)$
windowrule = float, class:^(nm-connection-editor)$
windowrule = size 45%, class:^(nm-connection-editor)$
windowrule = center, class:^(nm-connection-editor)$

windowrule = float, class:^(.*plasmawindowed.*)$
windowrule = float, class:^(kcm_.*)$
windowrule = float, class:^(.*bluedevilwizard)$
windowrule = float, title:^(illogical-impulse Settings)$
windowrule = float, title:^(.*Shell conflicts.*)$

# Zotero, JetBrains тощо
windowrule = float, class:^(Zotero)$
windowrule = size 45%, class:^(Zotero)$
windowrule = noinitialfocus, class:^jetbrains-.*$,floating:1,title:^$|^\s$|^win\d+$

# Picture-in-Picture
windowrule = float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$
windowrule = pin, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$
windowrule = size 25%, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$
windowrule = move 73% 72%, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$

# Тірінг для ігор
windowrule = immediate, title:.*\.exe
windowrule = immediate, title:.*minecraft.*
windowrule = immediate, class:^(steam_app).*

# Без тіні для тайлових вікон
windowrule = noshadow, floating:0

# Глобальний блюр — за потребою (розкоментуй, якщо хочеш)
# windowrule = noblur, class:.*
  '';
}
