#!/bin/bash
# Blokuj tylko gdy zasilacz NIE jest podłączony
for ps in /sys/class/power_supply/A{C,DP}*/online; do
    [ -f "$ps" ] && [ "$(cat "$ps")" = "1" ] && exit 0
done
loginctl lock-session