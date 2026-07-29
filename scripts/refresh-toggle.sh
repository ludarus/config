#!/bin/sh

refresh=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .current_mode.refresh')

case "$refresh" in 
	60000) swaymsg output eDP-1 mode 2560x1600@240Hz ;;
	240000) swaymsg output eDP-1 mode 2560x1600@60Hz ;; 
	*) echo "idk" ;;
esac
