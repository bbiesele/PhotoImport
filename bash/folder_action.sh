#!/usr/bin/env bash

#  folder_action.sh
#  attach to PhotosInbound
#
#  Created by William Biesele on 4/3/18.
#  Copyright © 2018 William Biesele. All rights reserved.
#!/bin/bash

#script to recursively travel a dir of n levels

# INnbound photo global constants
#

#. /Users/william/scripts/PhotosInbound/InboundENV.sh
# Location of flat directories
DATASTORE=/Volumes/MiniPhoto/OlympusViewer3/
# location of logs
LOGFILE=/Users/william/Pictures/Inbound.log
# location of backup directory all files are copied here preserving dirs
BACKUP=/Volumes/PhotoBkup/Loads/
# location of y/m/d directory tree
CATALOG=/Users/william/Pictures/Catalog
# location of scripts and exif control files
SCRIPT=$( basename $0)
CONTROLS=$( dirname $0)
# use one date time for this run
DATE=`date +%Y-%m-%d`


# ########################
# File handling here
File ()
{
    dir=$(dirname "$1")
    base=$(basename "$1") 2> /dev/null
    ymd=$(/usr/local/bin/exiftool -d "%Y_%m_%d" -T -s3 -r -q -DateTimeOriginal "$1" )
    if [[ "$ymd" = "-" ]] ; then
        # GOPRO movies have minimal EXIF data but good QUICKTIME
        ymd=$(/usr/local/bin/exiftool -d "%Y_%m_%d" -T -s3 -r -q -TrackCreateDate "$1" )
    fi
    slashed=$(echo "$ymd" | sed 's/_/\//g')
    yymm=$(dirname "$slashed")
    [[ -d "$DATASTORE/$ymd/" ]] || mkdir "$DATASTORE/$ymd/"
    echo -e "COPY $1 $ymd -> $DATASTORE/$ymd/$base" >> $LOGFILE
    cp -ap "$1" "$DATASTORE/$ymd/$base"
    # if needed create the link from the datastore yyyy_mm_dd to catalogs yyyy/mm/dd
    # if needed create the yyyy/mm entry in the catalog    yymm = $(dirname "$slashed")
    if [ ! -e "$CATALOG/$yymm" ]; then
        echo -e "mkdir -p $CATALOG/$yymm"  >> $LOGFILE
        mkdir -p "$CATALOG"/"$yymm"
    fi
    # if needed create the link from the datastore yyyy_mm_dd to catalogs yyyy/mm/dd
    if [ ! -e "$CATALOG/$slashed" ]; then
        echo -e "ln -sF $DATASTORE/$ymd $CATALOG/$slashed" >> $LOGFILE
        ln -sFv "$DATASTORE/$ymd" "$CATALOG/$slashed" >> $LOGFILE 2>> $LOGFILE
    fi
}



# ########################
# handle a directory
Dir ()
{
    save=$Indent
    # loop through entries in the directory
    # and handle appropriately
    # this flattens directory trees
    echo "DIR" "$1" >> $LOGFILE
    for filename in "$1"/*
    do
        if [ -d "$filename" ]; then
            Dir  "$filename"
       else
            File "$filename"
        fi
    done
}

# ########################
#
#   Start
#
# ########################
#verify needed directories exist, if not create
# data
[[ -d "$DATASTORE" ]] || mkdir -p "$DATASTORE"
# catalog
[[ -d "$CATALOG" ]] || mkdir -p "$CATALOG"
# backup
[[ -d "$BACKUP" ]] || mkdir -p "$BACKUP"

# #######################
# arg[1] is the directory/file added
#
# Backup the whole directory or the file
no_spaces=$( echo $( basename "$1") |sed -e 's/ /_/g')
echo "$DATE Start $0 $@ $no_spaces"  >> $LOGFILE
mkdir -p "$BACKUP$DATE"
cp -npRv "$1" "$BACKUP$DATE/$no_spaces-$$" >> $LOGFILE
echo "cp -npRv $1 $BACKUP$DATE/$no_spaces-$$" >> $LOGFILE

# ########################
# traverse the tree
for filename in "$1"
do
#    echo -e "START $filename" >> $LOGFILE
    if [ -d "$filename" ]; then
        Dir  "$filename"
    else
        File "$filename"
    fi
#    echo -e "END $filename" >> $LOGFILE
done
echo "End $0 $@ $no_spaces"  >> $LOGFILE


