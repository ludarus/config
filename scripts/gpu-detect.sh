#!/bin/sh
hybrid="$(sudo legion_cli hybrid-mode-status | tail -n1)"

case "$hybrid" in
True)
	echo "hybrid mode"
	exec sway
   ;;

False)
	echo "dgpu mode"
	exec sway --unsupported-gpu
   ;;
*) echo unknown hybrid mode state ;;
esac
