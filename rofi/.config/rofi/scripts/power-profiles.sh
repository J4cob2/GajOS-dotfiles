#!/bin/bash

options=" Power-saver\n Balanced\n Performance"

chosen=$(echo -e "$options" | rofi -dmenu -theme "~/.config/rofi/themes/power-profiles.rasi" -p "⏻ Power-profiles")

case "$chosen" in 
    " Power-saver") powerprofilesctl set power-saver;;
    " Balanced") powerprofilesctl set balanced;;
    " Performance") powerprofilesctl set performance;;
esac