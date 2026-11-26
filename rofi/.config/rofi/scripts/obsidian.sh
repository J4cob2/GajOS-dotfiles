#!/bin/bash

options=" Personal\n  Projects\n Dungeons&Dragons\n󰙀 University"

chosen=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/themes/theme.rasi -p " Obsidian Vaults")

case "$chosen" in
    " Personal") xdg-open "obsidian://open?vault=01-Personal";;
    "  Projects") xdg-open "obsidian://open?vault=02-Projects";;
    " Dungeons&Dragons") xdg-open "obsidian://open?vault=03-Dungeons%26Dragons";;
    "󰙀 University") xdg-open "obsidian://open?vault=04-University";;
esac
