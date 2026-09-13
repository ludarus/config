#!/bin/sh
# Fuzzy directory picker that runs in a kitty overlay window.
# Launched via a kitty `map` binding. Because it runs in its own overlay
# window, fzf gets a clean terminal with no zsh/ZLE input contention, so
# no keypresses are dropped.
#
# After a directory is chosen, it uses kitty remote control to type
# `cd <dir>` into the parent window (matched via state:overlay_parent).

# Directory list is read from a shared config file (single source of truth).
# Edit that file to add/remove directories; both Ctrl+F and `fcd` use it.
FCD_CONF="${FCD_CONF:-$HOME/.config/fcd/dirs.conf}"

# Build candidate list: each existing root plus its immediate subdirectories.
# Read the config, skipping blank lines and comments, expanding ~ to $HOME.
roots=""
while IFS= read -r line; do
	case "$line" in
	'' | \#*) continue ;;
	esac
	case "$line" in
	"~" | "~/"*) line="$HOME${line#\~}" ;;
	esac
	[ -d "$line" ] && roots="$roots $line"
done <"$FCD_CONF"
[ -n "$roots" ] || exit 0

sel=$(
	{
		for r in $roots; do printf '%s\n' "$r"; done
		fd --type d --hidden --follow --no-ignore --max-depth 1 \
			--exclude .git --exclude node_modules --exclude .cache \
			. $roots 2>/dev/null
	} | sed "s|^$HOME|~|" | fzf --prompt="cd > " --reverse --no-mouse
)

[ -n "$sel" ] || exit 0

# The list shows ~ for readability; expand it back to the real path for cd.
case "$sel" in
"~" | "~/"*) sel="$HOME${sel#\~}" ;;
esac

# Send the cd command back to the window beneath this overlay.
# `state:overlay_parent` is provided by kitty specifically to match the
# window that launched this overlay.
kitten @ send-text --match "state:overlay_parent" "cd '$sel'\n"
