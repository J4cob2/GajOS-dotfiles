#!/bin/bash

options=" Personal\n Godot"

chosen=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/themes/theme.rasi -p " Projects")

case "$chosen" in
    " Persnoal") ;;
    " Godot") ;;
esac