#!/bin/bash

options="Hyprland\nWaybar\nRofi\nNvim\nMatugen\nWlogout\nScripts"

chosen=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/themes/theme.rasi -p " Configurations")

case "$chosen" in
    "Hyprland") kitty --working-directory ~/.config/hypr nvim;;
    "Waybar") kitty --working-directory ~/.config/waybar nvim;;
    "Rofi") kitty --working-direcotry ~/.config/rofi nvim;;
    "Nvim") kitty --working-directory ~/.config/nvim nvim;;
    "Matugen") kitty --working-directory ~/.config/matugen nvim;;
    "Wlogout") kitty --working-directory ~/.config/wlogout nvim;;
    "Scripts") kitty nvim --working-direcotry ~/.config/scripts nvim;;
esac
