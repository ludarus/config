#!/usr/bin/env bash
# Toggle the laptop display (eDP-1) between 60 Hz and 240 Hz.
set -euo pipefail

rate=$(hyprctl monitors -j | jq -r '.[] | select(.name=="eDP-1") | .refreshRate')

if [ "${rate%.*}" -ge 180 ]; then
	target=60
else
	target=240
fi

hyprctl eval "hl.monitor({ output = \"eDP-1\", mode = \"2560x1600@${target}\", position = \"3840x0\", scale = 1 })"
