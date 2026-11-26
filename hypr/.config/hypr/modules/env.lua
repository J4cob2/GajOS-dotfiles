-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Globalny motyw Qt 5 / Qt 6
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Preferuj natywne uruchamianie aplikacji Electron/Chromium
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")