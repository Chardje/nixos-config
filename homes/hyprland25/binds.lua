local mod = "SUPER"
local terminal = "foot"
local fileManager = "nemo"
local browser = "firefox"
local audioControl = "pavucontrol"

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("caelestia shell drawers toggle launcher"))
hl.bind(mod .. " + mouse:272", hl.dsp.exec_cmd("caelestia-shell launcherInterrupt"))
hl.bind(mod .. " + mouse:273", hl.dsp.exec_cmd("caelestia-shell launcherInterrupt"))
hl.bind(mod .. " + mouse:274", hl.dsp.exec_cmd("caelestia-shell launcherInterrupt"))
hl.bind(mod .. " + mouse:275", hl.dsp.exec_cmd("caelestia-shell launcherInterrupt"))
hl.bind(mod .. " + mouse:276", hl.dsp.exec_cmd("caelestia-shell launcherInterrupt"))
hl.bind(mod .. " + mouse:277", hl.dsp.exec_cmd("caelestia-shell launcherInterrupt"))
hl.bind(mod .. " + mouse_up", hl.dsp.exec_cmd("caelestia-shell launcherInterrupt"))
hl.bind(mod .. " + mouse_down", hl.dsp.exec_cmd("caelestia-shell launcherInterrupt"))

hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("caelestia shell drawers toggle session"))
hl.bind(mod .. " + Delete", hl.dsp.exec_cmd("caelestia shell notifs clear"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("caelestia shell lock lock"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("caelestia shell brightness set +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("caelestia shell brightness set 10%-d"))

hl.bind("CTRL + " .. mod .. " + SPACE", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("CTRL + " .. mod .. " + equal", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("CTRL + " .. mod .. " + minus", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))

hl.bind("CTRL + " .. mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mod .. " + Page_Up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mod .. " + Page_Down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mod .. " + A", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mod .. " + D", hl.dsp.focus({ workspace = "+1" }))

hl.bind(mod .. " + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mod .. " + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mod .. " + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mod .. " + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("CTRL + " .. mod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("CTRL + " .. mod .. " + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))

hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ workspace = "e+0" }))
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("special"))

hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mod .. " + minus", hl.dsp.window.resize({ x = -50, y = 0 }))
hl.bind(mod .. " + equal", hl.dsp.window.resize({ x = 50, y = 0 }))

hl.bind("CTRL + " .. mod .. " + backslash", hl.dsp.window.center())

hl.bind(mod .. " + C", hl.dsp.window.kill())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + X", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pin())
hl.bind(mod .. " + T", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd(audioControl))

hl.bind(mod .. " + V", hl.dsp.exec_cmd("sh -c 'pkill fuzzel || cliphist list | fuzzel | xargs wl-copy'"))
hl.bind(mod .. " + ALT + V", hl.dsp.exec_cmd("sh -c 'pkill fuzzel || cliphist list | fuzzel | xargs wl-copy'"))
hl.bind(mod .. " + period", hl.dsp.exec_cmd("sh -c 'pkill fuzzel || wofi-emoji'"))
hl.bind("CTRL + SHIFT + ALT + V", hl.dsp.exec_cmd("sh -c 'sleep 0.5s && ydotool type -d 1 \"$(cliphist list | head -1 | cliphist decode)\"'"))

hl.bind("Print", hl.dsp.exec_cmd("sh -c 'grim - | wl-copy'"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("sh -c 'slurp | grim -g - - | wl-copy'"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("sh -c 'pkill wf-recorder'"))
hl.bind(mod .. " + ALT + R", hl.dsp.exec_cmd("sh -c 'wf-recorder -g \"$(slurp)\" -f ~/videos/recording-$(date +%F-%T).mp4'"))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))

hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend-then-hibernate"))
