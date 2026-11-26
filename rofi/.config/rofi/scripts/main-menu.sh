#!/bin/bash

options="󰣇 Applications\n Obsidian Vaults\n Projects\n Configurations\n WiFi\n Bluetooth\n⏻ Power-profiles"

chosen=$(echo -e "$options" | rofi -dmenu ~/.config/rofi/scripts/main-menu.sh -theme ~/.config/rofi/themes/theme.rasi -p "Menu")

case "$chosen" in
    "󰣇 Applications") ~/.config/rofi/scripts/apps.sh;;
    " Obsidian Vaults") ~/.config/rofi/scripts/obsidian.sh;;
    " Projects") ~/.config/rofi/scripts/projects.sh;;
    " Configurations") ~/.config/rofi/scripts/configurations.sh;;
    " WiFi") ~/.config/rofi/scripts/wifi.sh;;
    " Bluetooth") ~/.config/rofi/scripts/bluetooth.sh;;
    "⏻ Power-profiles") ~/.config/rofi/scripts/power-profiles.sh;;
esac
