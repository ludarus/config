#!/bin/sh

case "$1" in
    toggle)
        profile=$(sudo tlp-stat -m | cut -d/ -f1)

        if [ "$profile" = "power-saver" ]; then
            sudo tlp performance
        else
            sudo tlp power-saver
        fi
        exit
        ;;
esac

profile=$(sudo tlp-stat -m | cut -d/ -f1)

case "$profile" in
    performance) echo "🔥" ;;
    balanced)    echo "" ;;
    power-saver) echo "" ;;
    *)            echo "?" ;;
esac
