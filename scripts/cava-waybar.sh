#!/usr/bin/env bash
# Bridge cava -> Waybar. Runs cava in raw/ascii mode and converts each frame's
# 0-7 values into block glyphs, printing one line per frame to stdout.
# Used by the Waybar "custom/cava" module (no return-type, continuous stdin).
#
# Visibility rule (purely signal-driven, playerctl is NOT consulted):
#   * Show the bars whenever there is any real audio signal in the frame.
#   * Keep showing them through brief silences; only hide the module after
#     SILENCE_HIDE seconds of CONTINUOUS silence.

config="$HOME/.config/cava/waybar_config"

# Seconds of uninterrupted silence before the module disappears.
SILENCE_HIDE=10

# Bail out quietly if cava isn't installed yet so Waybar just shows nothing.
if ! command -v cava >/dev/null 2>&1; then
    exit 0
fi

# Block glyphs for levels 0..7.
bars="▁▂▃▄▅▆▇█"

# Timestamp (epoch seconds) of the last frame that carried real signal.
last_signal=0

cava -p "$config" | while IFS= read -r frame; do
    # Strip the trailing ';' delimiters, leaving just the digits.
    digits="${frame//;/}"

    now=$(date +%s)

    if [[ "$digits" =~ [1-7] ]]; then
        # Real signal this frame -> remember it and show the bars.
        last_signal=$now
    fi

    # Show as long as we've seen signal within the last SILENCE_HIDE seconds.
    if [ $((now - last_signal)) -lt "$SILENCE_HIDE" ]; then
        out=""
        i=0
        while [ "$i" -lt "${#digits}" ]; do
            d="${digits:$i:1}"
            out="${out}${bars:$d:1}"
            i=$((i + 1))
        done
        printf '%s\n' "$out"
    else
        # 10+ seconds of continuous silence -> hide the module.
        printf '\n'
    fi
done
