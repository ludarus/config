#!/usr/bin/env bash

BATTERY=$(< /sys/class/power_supply/BAT0/capacity)
STATUS=$(< /sys/class/power_supply/BAT0/status)

# Only notify while discharging
if [ "$STATUS" = "Discharging" ]; then
    if [ "$BATTERY" -le 15 ]; then
        notify-send -u critical -t 0 \
            "Battery Critical" \
            "Battery is at ${BATTERY}%, connect to AC power immediately"
    elif [ "$BATTERY" -le 25 ]; then
        notify-send -u normal \
            "Battery Low" \
            "Battery is at ${BATTERY}%."
    fi
fi
