#!/usr/bin/env bash

refresh=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .current_mode.refresh')

echo "$refresh"

case "$refresh" in
60000)
	swaymsg output eDP-1 mode 2560x1600@240Hz
	swaymsg output HDMI-A-1 mode 3840x2160@120Hz
	;;
119999)
	swaymsg output eDP-1 mode 2560x1600@60Hz
	swaymsg output HDMI-A-1 mode 3840x2160@60Hz
	;;
240000)
	swaymsg output eDP-1 mode 2560x1600@60Hz
	swaymsg output HDMI-A-1 mode 3840x2160@60Hz
	;;
*) echo "idk" ;;
esac
