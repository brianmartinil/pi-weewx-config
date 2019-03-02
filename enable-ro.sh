#!/bin/bash

if [ -e /disable-root-ro ]; then
  rm /disable-root-ro

  echo "Magic file deleted.  Reboot to enter read-only mode."
fi
