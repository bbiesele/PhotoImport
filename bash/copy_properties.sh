#!/usr/bin/env bash

# ##########################################
#
# Define globals common to all scripts
#
# ##########################################


readonly __DATE=$(date "+%Y_%m_%d")
readonly __TIMESTAMP=$(date "+%Y_%m_%d %R:%S")
#readonly __LOGFILE="/Users/william/Pictures/Logs/$__SCRIPT-$__DATE-$$.log"
readonly __LOGFILE=STDERR
readonly __OS=$OSTYPE
TRACELEVEL="INFO"
DESTINATION="./"

# some are os dependent this is location of log4sh
if [[ "$OSTYPE" =~ ^darwin ]]; then
    readonly LOGGER_DIRECTORY="/Users/william/PycharmProjects/PhotoLoad/log4sh"
    LOG4SH_CONFIGURATION='none' . $LOGGER_DIRECTORY/log4sh

elif [[ "$OSTYPE" =~ ^linux ]]; then
    readonly LOGGER_DIRECTORY="/home/william/PycharmProjects/log4sh-1.4.2/src/shell"
    LOG4SH_CONFIGURATION='none' . $LOGGER_DIRECTORY/log4sh
else
    echo "Fatal error unknown OS $__OS"
    exit -1
fi
