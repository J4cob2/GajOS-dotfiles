#!/usr/bin/env bash

# ============================================================
# Rofi Wi-Fi manager
# NetworkManager + iwd
# ============================================================

ROFI="rofi"
NMCLI="nmcli"

# ------------------------------------------------------------
# Rofi options
# ------------------------------------------------------------

ROFI_OPTIONS=(
    -dmenu
    -i
    -p "Wi-Fi"
    -theme-str 'window { width: 500px; }'
)

# ------------------------------------------------------------
# Notifications
# ------------------------------------------------------------

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Wi-Fi" "$1"
    fi
}

# ------------------------------------------------------------
# Current connection
# ------------------------------------------------------------

get_current_wifi() {
    nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device status |
        awk -F: '
            $2 == "wifi" &&
            $3 == "connected" {
                print $4
                exit
            }
        '
}

# ------------------------------------------------------------
# Wi-Fi state
# ------------------------------------------------------------

get_wifi_state() {
    nmcli radio wifi
}

# ------------------------------------------------------------
# Wait until wlan0/device is ready
# ------------------------------------------------------------

wait_for_wifi() {
    local i

    for i in {1..10}; do

        if nmcli device status |
            awk '$1 == "wlan0" && $2 == "wifi" && $3 != "unavailable" {
                found=1
            }
            END {
                exit !found
            }'
        then
            return 0
        fi

        sleep 0.5
    done

    return 1
}

# ------------------------------------------------------------
# Enable Wi-Fi
# ------------------------------------------------------------

enable_wifi() {

    nmcli radio wifi on >/dev/null 2>&1

    # Czekamy aż NetworkManager przywróci urządzenie
    wait_for_wifi

    # Dajemy iwd/NM chwilę na inicjalizację
    sleep 1

    # Wymuszamy skanowanie
    nmcli device wifi rescan >/dev/null 2>&1

    sleep 1
}

# ------------------------------------------------------------
# Disable Wi-Fi
# ------------------------------------------------------------

disable_wifi() {
    nmcli radio wifi off >/dev/null 2>&1
}

# ------------------------------------------------------------
# Get visible networks
# ------------------------------------------------------------

get_visible_networks() {

    nmcli -t \
        -f SSID,SIGNAL,SECURITY \
        device wifi list |
    awk -F: '
        $1 != "" {
            print $1
        }
    ' |
    sort -u
}

# ------------------------------------------------------------
# Get saved NetworkManager connections
# ------------------------------------------------------------

get_saved_networks() {

    nmcli -t \
        -f TYPE,NAME \
        connection show |
    awk -F: '
        $1 == "802-11-wireless" {
            print $2
        }
    '
}

# ------------------------------------------------------------
# Build network list
# ------------------------------------------------------------

get_networks() {

    {
        get_visible_networks
        get_saved_networks
    } |
    sed '/^$/d' |
    sort -u
}

# ------------------------------------------------------------
# Network menu
# ------------------------------------------------------------

network_menu() {

    local ssid="$1"

    while true; do

        local current
        current="$(get_current_wifi)"

        local status=""

        if [[ "$ssid" == "$current" ]]; then
            status="● Connected"
        else
            status="○ Disconnected"
        fi

        local choice

        choice=$(
            printf '%s\n' \
                "$status" \
                "󰖩  Connect" \
                "󰖪  Disconnect" \
                "󰆴  Forget network" \
                "←  Back" |
            "$ROFI" \
                -dmenu \
                -i \
                -p "$ssid" \
                -theme-str 'window { width: 500px; }'
        )

        case "$choice" in

            "󰖩  Connect")

                if nmcli connection up "$ssid" >/dev/null 2>&1; then
                    notify "Connected to $ssid"
                else

                    # Jeśli profil nie istnieje albo wymaga hasła,
                    # próbujemy standardowego połączenia.
                    password=$(
                        "$ROFI" \
                            -dmenu \
                            -password \
                            -p "Password"
                    )

                    if [[ -n "$password" ]]; then

                        if nmcli device wifi connect "$ssid" \
                            password "$password" >/dev/null 2>&1
                        then
                            notify "Connected to $ssid"
                        else
                            notify "Failed to connect to $ssid"
                        fi
                    fi
                fi

                sleep 1
                ;;

            "󰖪  Disconnect")

                if nmcli connection down "$ssid" >/dev/null 2>&1; then
                    notify "Disconnected from $ssid"
                else
                    notify "Failed to disconnect"
                fi

                sleep 0.5
                ;;

            "󰆴  Forget network")

                if nmcli connection delete "$ssid" >/dev/null 2>&1; then
                    notify "Forgot $ssid"
                else
                    notify "Failed to forget $ssid"
                fi

                return
                ;;

            "←  Back"|"")
                return
                ;;

        esac
    done
}

# ------------------------------------------------------------
# Main menu
# ------------------------------------------------------------

main_menu() {

    while true; do

        local wifi_state
        wifi_state="$(get_wifi_state)"

        local current
        current="$(get_current_wifi)"

        # ----------------------------------------------------
        # Header / toggle
        # ----------------------------------------------------

        if [[ "$wifi_state" == "enabled" ]]; then
            toggle="󰖩  Disable Wi-Fi"
        else
            toggle="󰖪  Enable Wi-Fi"
        fi

        # ----------------------------------------------------
        # Build menu
        # ----------------------------------------------------

        local menu="$toggle"

        local networks
        networks="$(get_networks)"

        if [[ -n "$networks" ]]; then

            while IFS= read -r ssid; do

                [[ -z "$ssid" ]] && continue

                if [[ "$ssid" == "$current" ]]; then
                    marker="●"
                else
                    marker="○"
                fi

                menu+=$'\n'"$marker  $ssid"

            done <<< "$networks"

        else

            menu+=$'\n'"No networks found"

        fi

        # ----------------------------------------------------
        # Rofi
        # ----------------------------------------------------

        local choice

        choice=$(
            printf '%s\n' "$menu" |
            "$ROFI" "${ROFI_OPTIONS[@]}"
        )

        [[ -z "$choice" ]] && exit 0

        # ----------------------------------------------------
        # Toggle Wi-Fi
        # ----------------------------------------------------

        if [[ "$choice" == "$toggle" ]]; then

            if [[ "$wifi_state" == "enabled" ]]; then

                disable_wifi

            else

                enable_wifi

            fi

            # Menu zostanie zbudowane od nowa.
            # Lista zapisanych sieci nie znika.
            continue
        fi

        # ----------------------------------------------------
        # Ignore empty result
        # ----------------------------------------------------

        [[ "$choice" == "No networks found" ]] && continue

        # ----------------------------------------------------
        # Extract SSID
        # ----------------------------------------------------

        local ssid

        ssid="${choice#●  }"
        ssid="${ssid#○  }"

        [[ -z "$ssid" ]] && continue

        # ----------------------------------------------------
        # Open network menu
        # ----------------------------------------------------

        network_menu "$ssid"

    done
}

# ============================================================
# Start
# ============================================================

main_menu

