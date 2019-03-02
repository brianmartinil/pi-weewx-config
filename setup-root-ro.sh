#!/bin/bash

set -e

# The rest of this file configures an overlay filesystem
echo "Configuring read-only overlay filesystem..."
cp root-ro /etc/initramfs-tools/scripts/init-bottom/root-ro
chmod 0755 /etc/initramfs-tools/scripts/init-bottom/root-ro

if ! grep -q overlay /etc/initramfs-tools/modules; then
  echo overlay >> /etc/initramfs-tools/modules
fi

mkinitramfs -o /boot/initrd

if ! grep -q "root-ro-driver=overlay" /boot/cmdline.txt; then
  sed -i.bak 's/rootwait/root-ro-driver=overlay rootwait/' /boot/cmdline.txt
  # This is necessary to rewrite the root paramter or root-ro will freak out
  sed -i.bak 's/root=[^ ]*/root=\/dev\/mmcblk0p2/' /boot/cmdline.txt
fi

if ! grep "boot.*defaults,ro" /etc/fstab; then
  awk '/\/boot/{$4="defaults,ro"}{print}' /etc/fstab > /tmp/fstab
  cp /tmp/fstab /etc/fstab
  rm /tmp/fstab
fi

if [ -f /boot/cmdline.txt.bak ]; then
  rm /boot/cmdline.txt.bak
fi

if ! grep -q "#OverlayFS" /boot/config.txt; then
  echo "#OverlayFS" >> /boot/config.txt
  echo "initramfs initrd followkernel" >> /boot/config.txt
  echo "ramfsfile=initrd" >> /boot/config.txt
  echo "ramfsaddr=-1" >> /boot/config.txt
fi

echo "Done, you should reboot now..."
