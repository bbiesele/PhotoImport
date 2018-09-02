#!/usr/bin/env bash

#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.
#
# usage scripts/CopySD.sh inbound_media_name external_drive_name WHO

# Source is the name of the SD Card
#    note SD disks are not automounted in Gallium
#    open in file manager first
SOURCE="/media/william/$1/DCIM"
# Destination is the location of the external drive
DESTINATION=$2
WHO=$(echo "$3" | tr a-z A-Z)
CONTROL=$( dirname $0)
SCRIPT=$( basename $0)
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
echo "$INBOUND" | tee -a $LOGFILE
[[ -d "$INBOUND" ]] || mkdir -p "$INBOUND"
# #######################
#
# Copy the sd cars files to the INBOUND
#
echo "$SOURCE" | tee -a $LOGFILE
#INBOUND="$INBOUND/$no_spaces"
# all devices use a DCIM directory, so to avoid conflicts
# we need a unique name for each incoming sd card, hence
# todo search for DCIM directory and start there, then drop $$
#cp -nupRv "$SOURCE" "$INBOUND" | tee -a $LOGFILE
cp -nupR "$SOURCE" "$INBOUND" | tee -a $LOGFILE

echo "End $0 $@" | tee -a $LOGFILE


