-- Hyprland configuration ported from ~/.config/sway (Hyprland 0.56+ Lua)
-- Source files are preserved under ~/.config/sway.

-- this entire thing is ai generated

local terminal = "kitty"
local launcher = "walker"
local mod = "SUPER"

----------------
-- MONITORS
----------------

hl.monitor({ output = "eDP-1", mode = "2560x1600@60", position = "3840x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@120", position = "0x0" })

----------------
-- AUTOSTART
----------------

hl.on("hyprland.start", function()
    -- Import the live Wayland session into the systemd user manager.
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE && " ..
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE && " ..
        "systemctl --user restart elephant.service walker.service")
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet")
    -- Bluetooth tray applet: auto-connects trusted devices (e.g. WH-1000XM6)
    -- in the background. Hyprland does not process XDG autostart, so without
    -- this you had to open blueman-manager to trigger a connection.
    hl.exec_cmd("blueman-applet")
    -- Start hyprpaper and apply the wallpaper once its IPC socket is live.
    --
    -- hyprpaper v0.8.4 reads `preload` from hyprpaper.conf but logs
    -- "Monitor eDP-1 has no target: no wp will be created" and attaches
    -- nothing, so the wallpaper MUST be pushed over IPC after startup.
    -- Note: on this version `preload` and `listloaded` are NOT valid IPC
    -- requests ("invalid hyprpaper request"); `wallpaper` and `listactive`
    -- ARE. So we poll `listactive` (not `listloaded`) to detect readiness,
    -- and we do not call `preload` over IPC (the conf file handles preload).
    --
    -- The blank monitor field ("," = all connected outputs) is used on
    -- purpose: HDMI-A-1 is not always plugged in. Naming it explicitly fails
    -- with "monitor not found" when absent; the blank field applies to
    -- whatever outputs are connected and skips the rest.
    hl.exec_cmd([[bash -c '
        pgrep -x hyprpaper >/dev/null || setsid hyprpaper >/dev/null 2>&1 &
        for i in $(seq 1 100); do
            hyprctl hyprpaper listactive >/dev/null 2>&1 && break
            sleep 0.05
        done
        hyprctl hyprpaper wallpaper ",/home/joe/eye.png"
    ']])

    -- Touchpad gestures: Hyprland does not process XDG autostart entries, so
    -- the libinput-gestures daemon must be started explicitly here. It reads
    -- ~/.config/libinput-gestures.conf (4-finger hold -> playerctl play-pause).
    hl.exec_cmd("libinput-gestures-setup start")

    -- swayidle remains usable under Hyprland; only the DPMS dispatch changed.
    hl.exec_cmd([[swayidle -w timeout 300 'swaylock -f -c 000000' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f -c 000000']])

    -- Preserve the Sway startup applications.
    hl.exec_cmd("zen-browser")
    hl.exec_cmd("discord")
    hl.exec_cmd("spotify-launcher")
    hl.exec_cmd("ticktick")
    hl.exec_cmd("obsidian")
end)

----------------
-- ENVIRONMENT
----------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

----------------
-- WALLPAPER
----------------

----------------
-- LOOK AND FEEL
----------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 0,
        resize_on_border = false,
        allow_tearing = true,
        layout = "dwindle",
        col = {
            active_border = "rgba(00000000)",
            inactive_border = "rgba(00000000)",
        },
    },

    decoration = {
        rounding = 15,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "0xee1a1a1a",
        },
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            xray = false,
            brightness = 1.0,
            contrast = 1.0,
            vibrancy = 0.0,
        },
    },

    animations = { enabled = true },
    dwindle = { preserve_split = true },
    master = { new_status = "master" },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
    cursor = { no_hardware_cursors = false },
})

----------------
-- INPUT / TOUCHPAD
----------------

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            disable_while_typing = false, -- Sway: dwt disabled
            tap_to_click = true,
            tap_and_drag = true,
            clickfinger_behavior = true, -- Sway: click_method clickfinger
            drag_lock = true,
            natural_scroll = true,
            middle_button_emulation = true,
        },
    },
})

-- Sway gestures.conf translated to native Hyprland gestures.
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "up", action = "float", mode = "float" })
hl.gesture({ fingers = 4, direction = "down", action = "float", mode = "tile" })
hl.gesture({ fingers = 3, direction = "swipe", action = "move" })
hl.gesture({ fingers = 3, direction = "pinch", action = "resize" })
-- hl.gesture({ fingers = 3, direction = "", action = "move" })
-- Four-finger hold -> playerctl play-pause is handled by libinput-gestures
-- (~/.config/libinput-gestures.conf), started from the autostart block above.
-- Hyprland's native gestures only support swipe/pinch, not tap or hold.

-- Keep the flat acceleration setting from the existing Hyprland config.
hl.device({
    name = "elan06fa:00-04f3:327e-touchpad",
    -- accel_profile = "flat",
})

----------------
-- WORKSPACES
----------------

for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end
for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end

----------------
-- KEYBINDINGS
----------------

hl.bind(mod .. " + period", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind("XF86RefreshRateToggle", hl.dsp.exec_cmd("/home/joe/scripts/refresh-toggle.sh"))
hl.bind(mod .. " + P", hl.dsp.exec_cmd("swaync-client -t -sw"))

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal .. " tmux new-session -A"))
hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal .. " tmux new"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("neovide ~"))
hl.bind(mod .. " + Q", hl.dsp.window.close())

hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(launcher .. " --set drun"))
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd(launcher .. " --set run"))
hl.bind(mod .. " + TAB", hl.dsp.exec_cmd(launcher .. " --set window"))
hl.bind(mod .. " + SHIFT + TAB", hl.dsp.exec_cmd(launcher .. " --set ssh"))

hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))

-- Focus windows with Vim keys (Sway: $mod+$left/$down/$up/$right = h/j/k/l).
local focus_keys = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(focus_keys) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
end

-- Move the focused window in a direction (Sway: $mod+Shift+$left etc.).
-- Sway's `move <dir>` shifts the window within the tiling layout, so the
-- direction-based dispatcher is the correct match rather than pixel moves.
local move_keys = { h = "l", j = "d", k = "u", l = "r" }
for key, direction in pairs(move_keys) do
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- Workspaces and moving windows to workspaces.
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- Cycle workspaces (Sway: $mod+Ctrl+$right / $mod+Ctrl+$left = l / h).
hl.bind(mod .. " + CTRL + l", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + CTRL + h", hl.dsp.focus({ workspace = "e-1" }))

-- Layouts. Dwindle has no direct stacking/tabbed/splith/splitv equivalents;
-- togglesplit (Sway: $mod+d "layout toggle split") is the closest match.
hl.bind(mod .. " + D", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + V", hl.dsp.window.fullscreen())
hl.bind(mod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Scratchpad -> named special workspace.
hl.bind(mod .. " + SHIFT + Escape", hl.dsp.window.move({ workspace = "special:scratchpad" }))
hl.bind(mod .. " + Escape", hl.dsp.workspace.toggle_special("scratchpad"))

-- Screenshots.
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind("Print", hl.dsp.exec_cmd("grim"))

-- Resizing mode from Sway's mode "resize".
hl.bind(mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("h", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
    hl.bind("l", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- Mod + mouse: click-drag to move (LMB) or resize (RMB) a window.
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume, brightness, and media keys.
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

----------------
-- WINDOW / WORKSPACE RULES
----------------

-- Application placement from Sway rules.conf. Class patterns include the
-- usual Wayland app_id values and common Hyprland class spellings.
-- NOTE: `match:class` is a RegEx (see Hyprland wiki). A literal dot is `\.`,
-- written "\\." in a Lua string. The previous config used Lua pattern escapes
-- ("%.") which the regex engine treats as a literal "%" followed by any char,
-- so rules like the Obsidian one never matched and windows landed on whatever
-- workspace happened to be focused at launch.
local app_workspaces = {
    { class = "^(ticktick|TickTick|com\\.ticktick\\.TickTick)$", workspace = "1" },
    { class = "^(zen|Zen|zen-browser)$", workspace = "2", idle_inhibit = "fullscreen" },
    { class = "^(md\\.obsidian\\.Obsidian|obsidian)$", workspace = "3" },
    { class = "^(Spotify|spotify)$", workspace = "4" },
    { class = "^(discord|Discord)$", workspace = "4" },
    { class = "^(STM32CubeIDE|stm32cubeide)$", workspace = "5" },
    { class = "^(com-st-microxplorer-maingui-STM32CubeMX|STM32CubeMX)$", workspace = "6" },
}
-- Rule names must be UNIQUE. The previous version named every rule
-- "sway-app-workspace-" .. workspace, so Spotify and discord (both workspace
-- "4") produced the same name "sway-app-workspace-4"; the second registration
-- silently overwrote the first, leaving Spotify with no workspace rule at all.
-- Index the name instead so each app gets its own rule.
for idx, rule in ipairs(app_workspaces) do
    local workspace = rule.workspace
    local idle_inhibit = rule.idle_inhibit
    local match = { class = rule.class }
    local spec = { name = "sway-app-workspace-" .. idx .. "-ws" .. workspace, match = match, workspace = workspace }
    if idle_inhibit then spec.idle_inhibit = idle_inhibit end
    hl.window_rule(spec)
end

-- Dialogs and utility windows that were floating under Sway.
hl.window_rule({ name = "blueman-manager-float", match = { class = "^blueman-manager$" }, float = true })
hl.window_rule({ name = "role-like-dialogs-float", match = { title = "^(Save|Open|Choose|Preferences|Properties|Dialog).*" }, float = true })

-- Preserve Sway's borderless window defaults and the XWayland drag workaround.
hl.window_rule({
    name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

----------------
-- NOTE ON Sway-ONLY LAYOUTS
----------------

-- Sway's stacking/tabbed/splith/splitv modes have no exact Hyprland
-- equivalent. Hyprland's dwindle layout plus togglesplit is used above.
