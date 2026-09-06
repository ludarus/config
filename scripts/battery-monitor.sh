#!/usr/bin/env bash

BATTERY=$(< /sys/class/power_supply/BAT0/capacity)
STATUS=$(< /sys/class/power_supply/BAT0/status)

STATE_FILE="$HOME/scripts/battery-notification"

# Create the state file if it doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
    echo 0 > "$STATE_FILE"
fi

STATE=$(< "$STATE_FILE")

# Reset notification state as the battery recovers.
# Critical resets once battery rises above 15%.
# Low resets once battery rises above 25%.
if (( BATTERY > 25 )); then
    STATE=0
elif (( BATTERY > 15 && STATE == 2 )); then
    STATE=1
fi

# Only send notifications while discharging
if [[ "$STATUS" == "Discharging" ]]; then
    # Critical battery
    if (( BATTERY <= 15 && STATE < 2 )); then
        notify-send -u critical -t 0 \
            "Battery Critical" \
            "Battery is at ${BATTERY}%, connect to AC power immediately"

        STATE=2

    # Low battery
    elif (( BATTERY <= 25 && STATE == 0 )); then
        notify-send -u normal \
            "Battery Low" \
            "Battery is at ${BATTERY}%."

        STATE=1
    fi
fi

echo "$STATE" > "$STATE_FILE"
