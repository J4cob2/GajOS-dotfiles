---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local powermenu   = "wlogout -b 1 -L 1780 -R 0 -T 215 -B 215 -r 0"
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "~/.config/rofi/scripts/main-menu.sh"
local codeeditor  = "vscodium -new-instance"
local musicplayer = "spotify"
local comunicator = "vesktop"
local browser     = "firefox"


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local secondMod = "SHIFT + SUPER"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(secondMod .. " + Q", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/restart.sh"))
hl.bind("XF86LaunchA",hl.dsp.exec_cmd("~/.config/rofi/scripts/wallpapers.sh"))

hl.bind(mainMod .. " + GRAVE", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(codeeditor))


hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + L", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Fullscreen or maximize with mainMod/secondMod + F11 key
hl.bind(mainMod .. " + F11", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(secondMod .. " + F11", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
-- Move window with secondMod + arrow keys
hl.bind(secondMod .. " + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(secondMod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(secondMod .. " + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(secondMod .. " + down",  hl.dsp.window.move({ direction = "down" }))

--------------------------
---- WORKSPACE  BINDS ----
--------------------------
hl.bind(mainMod .. " + TAB",hl.dsp.focus({monitor = "+1"}))

for i = 1, 10 do
    local key = tostring(i % 10)

    hl.bind(mainMod .. " + " .. key, function()
    local monitor = hl.get_active_monitor()

    if monitor and monitor.name == "eDP-1" then
        hl.dispatch(hl.dsp.focus({ workspace = tostring(i) }))
    elseif monitor and (monitor.name == "DP-5" or monitor.name == "HDMI-A-2") then
        hl.dispatch(hl.dsp.focus({ workspace = tostring(i + 10) }))
    end
end)

    hl.bind(secondMod .." + ".. key, function()
        local monitor = hl.get_active_monitor()

        if monitor and monitor.name == "eDP-1" then
            hl.dispatch(hl.dsp.window.move({ workspace = tostring(i) }))
        elseif monitor and (monitor.name == "DP-5" or monitor.name == "HDMI-A-2") then
            hl.dispatch(hl.dsp.window.move({ workspace = tostring(i + 10) }))
        end
    end)
end

-- Check if app is open if not open, if open just open/close special workspace
local function window_exists(class)
  for _, w in ipairs(hl.get_windows()) do
    if w.class == class then
      return true
    end
  end
  return false
end

hl.bind(mainMod .. " + D", function()
  if not window_exists("^vesktop$") then
    hl.exec_cmd(comunicator)
  end
  hl.dispatch(hl.dsp.workspace.toggle_special("discord"))
end)

hl.bind(mainMod .. " + S", function()
  if not window_exists("^Spotify$") then
    hl.exec_cmd(musicplayer)
  end
  hl.dispatch(hl.dsp.workspace.toggle_special("spotify"))
end)


-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })



-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

