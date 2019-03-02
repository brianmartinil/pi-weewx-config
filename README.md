# pi-weewx-config

These are some scripts I wrote to help configure WeeWX on a Raspberry Pi.

Descriptions of the individual scripts are below.  This has only been
tested on Raspbian Jessie Lite, 2017-07-05 build, and even then not very
thorougly.

The usual steps to run this are:
1. Write a fresh Raspian image
2. Customize `weewx.conf`
3. Run `sudo setup-software.sh` to set up the software on the Pi and install
   WeeWX.
4. Once you are happy with the way things are running, run `sudo setup-root-ro.sh`
   to make the filesystem read only.

### setup-software.sh

This script sets the hostname and timezone, installs WeeWX,
copies the provided WeeWX config file, and uninstalls
a few un-needed packages.  Edit the variables at the top of the script to
change the hostname.  Expects a file called `weewx.conf` in the same
directory.

### setup-root-ro.sh

Configures the root filesystem to be read-only and installs a read/write
overlay.  Any changes to the overlay will be erased at reboot.  Also makes
the `/boot` partition read-only.

### disable-ro.sh, enable-ro.sh

Enables and disables the overlay and read-only attribute on the root
filesystem.  You need to reboot after running the command.

## Credits

Elements of the script were borrowed from various forum posts.  Unfortunately
I lost track of most of the sources.

The `root-ro` script is taken from here and slightly modified:  https://gist.githubusercontent.com/kidapu/a03dd5bb8f4ac6a4c7e69c28bacde1d3/raw/83c7922c6c7962548ab0eb3666a7618b09ead270/root-ro
