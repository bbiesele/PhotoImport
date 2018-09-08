#!/usr/bin/env bash

#  CopyMedia.sh
#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.

#  Copy DCIM directory from newly mounted SD card or whatever
#
#  use fswatch on linux
#  use fswatch or Automator on OS X
#    to watch the parent directory where media are mounted
#    captured as $MEDIA_VOLUME in copy_properties.sh
#  first (and only) argument is the name of the head directory of the mounted card
#
#   This script searches for a DCIM directory in the head directory
#       if found it searches for a COPY file
#            if found it copies all files after the date of the COPY file
#            if not found it copies all files
#        copies those file to the $INBOUND directory
#        touches a COPY file to tag the date


# source PhotoImport globals
. ./copy_properties.sh

main() {
    prep_log
    if [ -d "$1/DCIM" ]
    then
        logger_info "found DCIM in $1"
        if [ ! -f "$1/DCIM/COPY" ]
        # if the copy exists we don't want to import twice!!
        # since the destination and source are on different volumes this does a cp
        then
            # get tags fpr this import
            osascript <<EOD
display notification "DCIM directory found" with title "Photo Import" sound_name Sosumi
EOD
            tags=$(osascript -e \
'try
    tell app "SystemUIServer"
        set answer to text returned of (display dialog "Enter tags" default answer "" with title "Volume Mounted")
    end
end
')
            find -X "$1/DCIM" -maxdepth 1 -exec cp -pR {} "$__INBOUND/DCIM$$" \;
            echo "$__INBOUND/DCIM$$" > "$1/DCIM/COPY"
            echo "$tags" > "$__INBOUND/DCIM$$/tags.txt"
            logger_info "copied $1/DCIM to $__INBOUND/DCIM$$"
        else
            prev_dir_file=$(cat "$1/DCIM/COPY")
            prev_file=$(basename "$prev_dir_file")
            osascript -e "display notification \"DCIM previously copied to $prev_file\"" with title "Photo Import"
            osascript <<END
tell app "System Events" to display dialog "This card previously copied to $prev_file" with title "Photo Import"
END
            logger_warn "This card has already been imported to $prev_file"
#TODO
#   let this copy any new files since the last import
        fi
    else
        osascript -e 'display notification "No DCIM directory found" with title "Photo Import Ignored"'
        logger_warn "No DCIM in $1"
    fi
}

# ########################
#
#   Start
#
# ########################
main "$1"
logger_info "Completed $(date "+%Y_%m_%d %R:%S")"
