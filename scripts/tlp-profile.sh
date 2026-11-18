#!/usr/bin/env bash

case "$1" in
toggle)
	profile=$(sudo tlp-stat -m | cut -d/ -f1)

	case "$profile" in
	power-saver) sudo tlp balanced ;;
	balanced) sudo tlp performance ;;
	performance) sudo tlp power-saver ;;
	*) sudo tlp power-saver ;;
	esac
	;;
esac

profile=$(sudo tlp-stat -m | cut -d/ -f1)

case "$profile" in
performance) echo "🔥" ;;
balanced) echo "" ;;
power-saver) echo "" ;;
*) echo "?" ;;
esac
