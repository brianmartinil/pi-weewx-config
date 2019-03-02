#!/bin/bash

sudo mount -o remount,rw /mnt/root-ro
touch /mnt/root-ro/disable-root-ro
sudo mount -o remount,ro /mnt/root-ro

echo "Magic file created.  Reboot to enter read-write mode."
