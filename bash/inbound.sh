#!/usr/bin/env bash

#  Laptop Inbound.sh
#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.


# usage:
# scripts/Inbound.sh external_drive_name

#TODO line from https://www.sno.phy.queensu.ca/~phil/exiftool/exiftool_pod.html#COPYING-EXAMPLES
#exiftool -b -jpgfromraw -w %d%f_%ue.jpg -execute -b -previewimage -w %d%f_%ue.jpg -execute -tagsfromfile @ -srcfile %d%f_%ue.jpg -overwrite_original -common_args --ext jpg DIR


# Destination is the location of the external drive
DESTINATION=$1
CONTROL=$( dirname $0)
DATE=$(date "+%Y_%m_%d")
TIMESTAMP=$(date "+%Y_%m_%d %R:%S")
# Inbound is where the input is backed up
INBOUND="/media/william/$DESTINATION/Inbound/$DATE/"
SAVE="/media/william/$DESTINATION/Save/"
echo "cp -nupRv $INBOUND $SAVE"
[[ -d "$SAVE" ]] || mkdir -p "$SAVE"
cp -upRv --backup=numbered "$INBOUND" "$SAVE"
# Stack is where the date directories are locatedn
STACK="/media/william/$DESTINATION/Stack/"
LOGFILE="/home/william/Pictures/Logs/Inbound$$.log"
echo "$@"  | tee $LOGFILE

# ########################
#
#   Start
#
# ########################
# just in case
echo "$STACK" | tee -a $LOGFILE
[[ -d "$STACK" ]] || mkdir -p "$STACK"
# check to create .gpx file
#    exiftool -m -r -ee -'if "$gpslatitude"' -fileOrdersdatetime -p ~/GPX/gpx.fmt \
#      	$INBOUND/* > "/home/william/GPX/$DATE-$$.gpx" \
#        | tee -a $LOGFILE

# set some tags
echo "set some tags" \
'-artist<= '"/home/william/$CONTROL/artist.txt" \
"$INBOUND" | tee -a $LOGFILE

exiftool -r -P -d -m -overwrite_original -ignoreMinorErrors \
    -artist='William and/or Susan Biesele. biesele.net'  \
    -rights<=' © 2018 William Biesele bbiesele@gmail.com All rights reserved'\
     "$INBOUND" | tee -a $LOGFILE

# ########################
# create jpg's for raw's without them
echo "missing jpgs\n" \
     "-ignoreMinorErrors -b -r -previewImage -w .JPG  \
    -ext ORF -ext CR2 -ext DNG \
    $INBOUND"
exiftool -ignoreMinorErrors -b -r -m -previewImage -w .JPG  \
    -ext ORF -ext CR2 \
    $INBOUND
# copy tags from raws
echo "tags from raw to jpg"
exiftool -r -ext ORF  \
    -tagsfromfile @ -srcfile %d%f.JPG \
    $INBOUND | tee -a $LOGFILE

#     -if '$FileModifyDate > "$TIMESTAMP"' \

# ########################
# set getags

#echo "set geotags /home/william/GPX/26-JUL-18"
#"$INBOUND" | tee -a $LOGFILE
#exiftool -r -P -d -overwrite_original -ignoreMinorErrors \
#    -geotag="/home/william/GPX/26-JUL-18.gpx" \
#    '-xmp:geotime<createdate' \
#    $INBOUND | tee -a $LOGFILE
 ########################

# ########################
# Copy to the Y/M/D directories and set some tags
echo 'to Y/M/D directories\
 -r -P -d '"$STACK"'%Y-%m-%d\
    -directory<${FileModifyDate}\
    -directory<${CreateDate}\
    -directory<${DateTimeOriginal}' | tee -a $LOGFILE

#date heirarchy
#remember this command moves files
#so subsequent calls don't affect files previously moved
#note exiftool web page gets this wrong
exiftool -r -m  \
     -d "$STACK%Y-%m-%d" \
    '-directory<${DateTimeOriginal}' \
     $INBOUND | tee -a $LOGFILE
exiftool -r -m  \
     -d "$STACK%Y-%m-%d" \
    '-directory<${CreateDate}' \
     $INBOUND | tee -a $LOGFILE
# all files have a FileModifyDate - its from the file system
exiftool -r -m  \
     -d "$STACK%Y-%m-%d" \
    '-directory<${FileModifyDate}' \
     $INBOUND | tee -a $LOGFILE
#     '-directory<${DateTimeOriginal}' -overwrite_original
echo "rm -r $INBOUND"
#the last exiftool moved the images and left*_original
#we don't want that messing stuff up
rm -r $INBOUND
echo "End $0 $@" | tee -a $LOGFILE


