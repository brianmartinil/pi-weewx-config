#!/bin/bash

WEATHER_TZ=US/Central
WEATHER_HOSTNAME=weatherstation

set -e

echo "Setting timezone..."
timedatectl set-timezone $WEATHER_TZ

echo "Changing hostname..."
raspi-config nonint do_hostname $WEATHER_HOSTNAME

echo "Installing WeeWX..."

if [ ! -f /etc/apt/sources.list.d/weewx.list ]; then
  wget -qO - http://weewx.com/keys.html | apt-key add -
  wget -qO - http://weewx.com/apt/weewx.list | tee /etc/apt/sources.list.d/weewx.list
fi

apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get install -y weewx

echo "Copying WeeWX config file..."
cp weewx.conf /etc/weewx/weewx.conf

echo "Restarting WeeWX.."
/etc/init.d/weewx restart

# TODO - Midnight reboot

if which dphys-swapfile; then
  echo "Disabling swap..."
  sudo dphys-swapfile swapoff
  sudo dphys-swapfile uninstall
  sudo update-rc.d dphys-swapfile remove
fi

echo "Removing some unneeded packages..."
apt-get remove -y --force-yes --purge triggerhappy logrotate dphys-swapfile fake-hwclock
apt-get -y --force-yes autoremove --purge

echo "Done"
