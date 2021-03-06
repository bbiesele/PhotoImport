#!/usr/bin/env bash

#  copy_gopro.sh
#    todo prone to failure

#    CopySD is more reliable for many files,
#      especially if used with USB2 NOT USB3
#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.

# Usage scripts/copy_gopro.sh external_disk_drive who

#./Users/william/scripts/PhotosInbound/InboundENV.sh
#usage:
#CopyMedia dest_external_drive WHO
#  TODO
#    Careful - implementation dependent
#    use $OSTYPE to determine os and thus location
[[ $OSTYPE = "linux_gnu" ]] || $GOPRO_DIR="$XDG_RUNTIME_DIR/gvfs/*"
#  TODO locate the directory via lsusb equivalent
if [[ $OSTYPE = darwin* ]]
then
  echo "Not available for $OSTYPE, use copy_sd instead or copy_location"
  exit 1001
fi

#Destination is the location of the external drive
DESTINATION=$1
# who is a user tag identifing the photographer
WHO=$(echo "$2" | tr a-z A-Z)
# refs from the command line
#CONTROL=$( dirname $0)
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
echo "$INBOUND " | tee -a $LOGFILE
[[ -d "$INBOUND" ]] || mkdir -p "$INBOUND"

# do the copy

cd  $XDG_RUNTIME_DIR/gvfs/*
# assumes only one such device
cd DCIM
ls
# and yes three steps are necessary
cp -nupR * "$INBOUND" | tee -a $LOGFILE

#echo "Please drag DCIM/* subdirectories to $INBOUND"
echo "DONE $0 $@"



