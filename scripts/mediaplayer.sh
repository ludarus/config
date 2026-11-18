#!/usr/bin/env bash
# Waybar now-playing module backed by playerctl (MPRIS), same source swaync's
# mpris widget uses. Outputs a JSON line for Waybar's return-type":"json".
#
# Player selection: when several MPRIS players exist, follow the ACTIVE one.
# A player that is Playing always wins over a paused one, so if one source is
# paused and another starts playing, the widget switches to the playing source.

# List all available players (one per line). Empty if none are running.
players=$(playerctl --list-all 2>/dev/null)

if [ -z "$players" ]; then
    # No MPRIS player running -> emit empty so the module hides.
    echo '{"text": "", "class": "stopped", "alt": "stopped"}'
    exit 0
fi

# Choose the player to display:
#   1. the first one reporting "Playing"
#   2. otherwise the first one reporting "Paused"
#   3. otherwise just the first player available
selected=""
first_paused=""
first_any=""

while IFS= read -r p; do
    [ -z "$p" ] && continue
    [ -z "$first_any" ] && first_any="$p"
    st=$(playerctl --player="$p" status 2>/dev/null)
    case "$st" in
        Playing)
            selected="$p"
            break
            ;;
        Paused)
            [ -z "$first_paused" ] && first_paused="$p"
            ;;
    esac
done <<< "$players"

if [ -z "$selected" ]; then
    if [ -n "$first_paused" ]; then
        selected="$first_paused"
    else
        selected="$first_any"
    fi
fi

# "player" mode: just print the selected player name (used by Waybar's
# on-click / on-scroll commands so they control the same player shown).
if [ "$1" = "player" ]; then
    printf '%s\n' "$selected"
    exit 0
fi

# Status + metadata for the selected player.
player_status=$(playerctl --player="$selected" status 2>/dev/null)
artist=$(playerctl --player="$selected" metadata artist 2>/dev/null)
title=$(playerctl --player="$selected" metadata title 2>/dev/null)
player_name=$(playerctl --player="$selected" metadata --format '{{ playerName }}' 2>/dev/null)
[ -z "$player_name" ] && player_name="$selected"

# Build the display text.
if [ -n "$artist" ] && [ -n "$title" ]; then
    info="${artist} - ${title}"
elif [ -n "$title" ]; then
    info="${title}"
else
    info="${player_name}"
fi

# Trim very long strings (Waybar also has max-length, this is a safety net).
max=50
if [ "${#info}" -gt "$max" ]; then
    info="${info:0:$max}…"
fi

# State icon.
case "$player_status" in
    Playing) icon="" ;;
    Paused)  icon="" ;;
    *)       icon="" ;;
esac

status_class=$(echo "$player_status" | tr '[:upper:]' '[:lower:]')

# Escape characters that break Pango/JSON.
escape() {
    sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e 's/"/\\"/g'
}
text=$(printf '%s %s' "$icon" "$info" | escape)
tooltip=$(printf '%s: %s' "$player_name" "$info" | escape)

printf '{"text": "%s", "tooltip": "%s", "class": "%s", "alt": "%s"}\n' \
    "$text" "$tooltip" "$status_class" "$status_class"
