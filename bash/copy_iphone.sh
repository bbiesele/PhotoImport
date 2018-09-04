#!/usr/bin/env bash

#  copy_media.sh
#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.


#. /Users/william/scripts/PhotosInbound/InboundENV.sh
# usage:
# copy_iphone dest_external_drive WHO
# Destination is the location of the external drive
#  TODO locate the directory via lsusb equivalent
if [[ $OSTYPE = darwin* ]]
then
  echo "Not available for $OSTYPE, use android_file_transfer instead with copy_location"
#  note make sure use USB device for file transfer is checked
#  if not aft will whine close it and check file transfer, that should open a working copy
#  this works fine in linux but Apple doens't support lsusb
  exit 1001
fi

DESTINATION=$1
WHO=$(echo "$2" | tr a-z A-Z)
CONTROL=$( dirname $0)
SCRIPT=$( basename $0 )
DATE=$(date "+%Y_%m_%d")
TIMESTAMP=$(date "+%Y_%m_%d %R:%S")
# Inbound is where the input is backed up
INBOUND="/media/william/$DESTINATION/Inbound/$DATE/$WHO/$$"
# So files are copied from SOURCE to INBOUND using the date of the run
#   cp -r --backup=t
LOGFILE="/home/william/Pictures/Logs/$SCRIPT-$DATE-$$.log"
echo "$@"  | tee $LOGFILE

# ########################
#
#   Start
#
# ########################
#verify needed directories exist, if not create
# backup
# all devices use a DCIM directory, so to avoid conflicts
# we need a unique name for each incoming sd card, hence
# todo search for DCIM directory and start there, then drop $$
echo "$INBOUND" | tee -a $LOGFILE
[[ -d "$INBOUND" ]] || mkdir -p "$INBOUND"

# do the copy
# someday when we can figure out device to file stuff
# for now just prompt where to drag and drop to
cd  $XDG_RUNTIME_DIR/gvfs/*
# assumes only one such device
cd DCIM/100APPLE
# Careful, it man create 101* etc
ls
# and yes three steps are necessary
cp -nupR * "$INBOUND" | tee -a $LOGFILE

#echo "Please drag DCIM/* subdirectories to $INBOUND"
echo "DONE $0 $@"



