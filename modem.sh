#!/bin/bash

## Created by blackhawk
# <luislopez72@gmail.com>
#
# This script makes the huawei modem works!!
# Please only use it when the network-manager
# sometimes show the modem connection and
# sometimes not.
#

echo "--- Starting ---"

# Save modules to a file
echo -n "* Checking loaded modules..."
modules="/tmp/modules.tmp"
lsmod > $modules
echo " [OK]"

# Unload usb-storage module
if grep usb_storage $modules > /dev/null ;
then
  echo -n "  * Removing usb-storage module..."
  if modprobe -r usb_storage 2>/dev/null;
  then
    echo " [OK]"
  else
    echo " [FAIL]"
    echo "     >> Please, remove any usb stick and try again <<"
    echo "--- Finished ---"
    exit 1
  fi
fi

# Load usbserial module
if grep usbserial $modules > /dev/null ;
then
  echo "  * Module 'usbserial' currently loaded [OK]"
else
  echo -n "  * Loading 'usbserial' module"
  if modprobe usbserial 2>/dev/null;
  then
    echo " [OK]"
  else
    echo " [FAIL]"
    echo "     >> Can not load module 'usbserial' <<"
    echo "--- Finished ---"
    exit 1
  fi
fi

# Kill all modem-manager
killall modem-manager

echo "--- Finished ---"
exit 0
