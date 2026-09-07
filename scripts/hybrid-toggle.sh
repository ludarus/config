#!/usr/bin/env bash

hybrid="$(sudo legion_cli hybrid-mode-status | tail -n1)"

case "$hybrid" in
True)
	# toggling state
	echo "Hybrid mode is currently enabled, toggling"
	echo "enabling dgpu mode"
	sudo legion_cli hybrid-mode-disable

	# switching grub config
	sudo cp /etc/default/grubDGPU /etc/default/grub
	# switching mkinitcpio config
	sudo cp /etc/mkinitcpio-nvidia.conf /etc/mkinitcpio.conf
	# mkinitcpio
	mkinitcpio -P
	# regenerating grub config
	sudo grub-mkconfig -o /boot/grub/grub.cfg
	;;

False)
	# toggling state
	echo "DGpu mode is currently enabled, toggling"
	echo "enabling hybrid mode"
	sudo legion_cli hybrid-mode-enable

	# switching grub config
	sudo cp /etc/default/grubIGPU /etc/default/grub
	# switching mkinitcpio config
	sudo cp /etc/mkinitcpio-hybrid.conf /etc/mkinitcpio.conf
	# mkinitcpio
	mkinitcpio -P
	# regenerating grub config
	sudo grub-mkconfig -o /boot/grub/grub.cfg
	;;
*) echo unknown hybrid mode state ;;

esac

if [[ "${1:-}" == "-r" ]]; then
	sudo reboot
fi

echo "Changes will apply on next reboot"
