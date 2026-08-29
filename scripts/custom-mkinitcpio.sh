#!/usr/bin/env bash

# generates two boot images for hybrid and dgpu
sudo mkinitcpio \
	-c /etc/mkinitcpio-hybrid.conf \
	-g /boot/initramfs-linux-hybrid.img

sudo mkinitcpio \
	-c /etc/mkinitcpio-nvidia.conf \
	-g /boot/initramfs-linux-nvidia.img
