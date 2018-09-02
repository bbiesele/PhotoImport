#!/usr/bin/env bash

#  Laptop CopyMedia.sh
#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.


# Inbound phot global constants
#

#. /Users/william/scripts/PhotosInbound/InboundENV.sh
# usage:
# copy_media.sh dest_external_drive WHO
# Destination is the location of the external drive
DESTINATION=$1
WHO=$(echo "$2" | tr a-z A-Z)
CONTROL=$( dirname $0)
SCRIPT=$( basename $0 )
DATE=$(date "+%Y_%m_%d")
TIMESTAMP=$(date "+%Y_%m_%d %R:%S")
# Inbound is where the input is backed up
INBOUND="/media/william/$DESTINATION/Inbound/$WHO/$DATE/"
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
#cd  $XDG_RUNTIME_DIR/gvfs/*
# assumes only one such device
#cd Internal\ shared\ storage/
#cd DCIM
# ls
# and yes three steps are necessary
# cp -nupR "$SOURCE" "$INBOUND" | tee -a $LOGFILE

echo "Please drag DCIM/* subdirectories to $INBOUND"
echo "DONE $0 $@"



