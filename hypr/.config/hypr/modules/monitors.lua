------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = "1",
})
hl.monitor({
    output   = "DP-5",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
})
hl.monitor({
    output   = "DP-6",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
})
hl.monitor({
    output   = "HDMI-A-2",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
})

--------------------------
---- WORKSPACE LAYOUT ----
--------------------------

-- eDP-1    -> 1 to 10
-- DP-5/DP-6     -> 11 to 20
-- HDMI-A-2 -> 11 to 20

hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
for i = 2, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "eDP-1",
        
    })
end

hl.workspace_rule({ workspace = "11", monitor = "DP-5", default = true })
for i = 12, 20 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-5",
        
    })
end

for i = 12, 20 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-6",
        
    })
end

for i = 12, 20 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "HDMI-A-2",
        
        
    })
end