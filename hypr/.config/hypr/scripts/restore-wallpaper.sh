#!/usr/bin/env bash

WALLPAPER="~/.cache/current-wallpaper"

# Czekamy na swww
sleep 2

if [[ -f "$WALLPAPER" ]]; then

    wallpaper="$(cat "$WALLPAPER")"

    if [[ -f "$wallpaper" ]]; then
        matugen image "$wallpaper" \
            --source-color-index 0 \
            --type scheme-smart
        awww img "$wallpaper" \
            --transition-type fade \
            --transition-duration 0.75
    fi
fi