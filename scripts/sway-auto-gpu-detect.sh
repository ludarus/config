#!/bin/sh

LOG=/tmp/sway-auto.log

echo "Sway-Auto starting" >> "$LOG"
echo "PATH=$PATH" >> "$LOG"
echo "USER=$USER" >> "$LOG"
echo "DISPLAY=$DISPLAY" >> "$LOG"
echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY" >> "$LOG"

hybrid="$(/usr/bin/legion_cli hybrid-mode-status 2>>"$LOG" | tail -n1)"

echo "hybrid=$hybrid" >> "$LOG"

case "$hybrid" in
    True)
        echo "hybrid mode" >> "$LOG"
        exec /usr/bin/sway
        ;;

    False)
        echo "dgpu mode" >> "$LOG"
        exec /usr/bin/sway --unsupported-gpu
        ;;

    *)
        echo "unknown hybrid mode state: '$hybrid'" >> "$LOG"
        exit 1
        ;;
esac
