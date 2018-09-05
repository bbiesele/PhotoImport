#!/usr/bin/env bash

readonly __DATE=$(date "+%Y_%m_%d")
readonly __TIMESTAMP=$(date "+%Y_%m_%d %R:%S")
#readonly __LOGFILE="/Users/william/Pictures/Logs/$__SCRIPT-$__DATE-$$.log"
readonly __LOGFILE=STDERR
readonly __LOGGER_DIRECTORY="/Users/william/PycharmProjects/PhotoLoad/log4sh"
readonly __LOGGER_DIRECTORY="/home/william/PycharmProjects/log4sh-1.4.2/src/shell/"
TRACELEVEL="INFO"
DESTINATION="./"
