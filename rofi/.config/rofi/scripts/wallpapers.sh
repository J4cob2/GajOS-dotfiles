#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

ROFI="rofi"
SWWW="awww"
MATUGEN="matugen"

# --------------------------------------------------
# Find wallpapers
# --------------------------------------------------

mapfile -t wallpapers < <(
    find "$WALLPAPER_DIR" \
        -type f \
        \( \
            -iname "*.jpg" \
            -o -iname "*.jpeg" \
            -o -iname "*.png" \
            -o -iname "*.webp" \
        \) |
    sort
)

# --------------------------------------------------
# Check if wallpapers exist
# --------------------------------------------------

[[ ${#wallpapers[@]} -eq 0 ]] && exit 0

# --------------------------------------------------
# Select wallpaper
# --------------------------------------------------

selected="$(
    for wallpaper in "${wallpapers[@]}"; do
        name="$(basename "$wallpaper")"

        printf '%s\0icon\x1f%s\n' \
            "$name" \
            "$wallpaper"
    done |
    "$ROFI" \
        -dmenu \
        -show-icons \
        -i \
        -p " Wallpapers" \
        -theme "$HOME/.config/rofi/themes/wallpapers.rasi"
)"

# --------------------------------------------------
# Exit if nothing selected
# --------------------------------------------------

[[ -z "$selected" ]] && exit 0

# --------------------------------------------------
# Find selected file
# --------------------------------------------------

wallpaper="$WALLPAPER_DIR/$selected"

[[ ! -f "$wallpaper" ]] && exit 1

# --------------------------------------------------
# Save current wallpaper
# --------------------------------------------------

mkdir -p "$HOME/.cache"

echo "$wallpaper" > "$HOME/.cache/current-wallpaper"

# --------------------------------------------------
# Change wallpaper
# --------------------------------------------------

"$SWWW" img "$wallpaper" \
    --transition-type fade \
    --transition-duration 0.75

# --------------------------------------------------
# Generate colors
# --------------------------------------------------

"$MATUGEN" image "$wallpaper" \
    --source-color-index 0 \
    --type scheme-smart