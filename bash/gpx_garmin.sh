#!/usr/bin/env bash

#  Laptop CopyMedia.sh
#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.


# Inbound phot global constants
#

#. /Users/william/scripts/PhotosInbound/InboundENV.sh
# usage:
# GPXGarmin
# Destination is the location of the external drive
CONTROL=$( dirname $0)
SCRIPT=$( basename $0 )
DATE=$(date "+%Y_%m_%d")
TIMESTAMP=$(date "+%Y_%m_%d %R:%S")
DESTINATION=~/GPX/$DATE
# Inbound is where the input is backed up
INBOUND="/media/william/GARMIN/Garmin/GPX/Current/"
# This does not rely on user input
# However it can be deleted after some work
# Best source would probably be the /Archive Directory
#    but, it isn't written till date change so not good for nightly runs
LOGFILE="/home/william/Pictures/Logs/$SCRIPT-$DATE-$$.log"
echo "$@"  | tee $LOGFILE
echo 'cp ' "$INBOUND  $DESTINATION"


# ########################
#
#   Start
#
# ########################
echo "$DESTINATION" | tee -a $LOGFILE
[[ -d "$DESTINATION" ]] || mkdir -p "$DESTINATION"

# do the copy
cp -R "$INBOUND" $DESTINATION| tee -a $LOGFILE

echo "if needed, drag drop* to $DESTINATION"
echo "DONE $0 $@"



