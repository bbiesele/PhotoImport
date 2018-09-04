#!/usr/bin/env bash

#  copy_location.sh
#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.

# #######################################################
#
# Globals
readonly __DATE=$(date "+%Y_%m_%d")
readonly __TIMESTAMP=$(date "+%Y_%m_%d %R:%S")
readonly __CONTROL=$( dirname $0)
readonly __SCRIPT=$( basename $0 )
#readonly __LOGFILE="/Users/william/Pictures/Logs/$__SCRIPT-$__DATE-$$.log"
readonly __LOGFILE=STDERR
readonly __LOGGER_DIRECTORY="/Users/william/PycharmProjects/PhotoLoad/log4sh"
TRACELEVEL="INFO"
DESTINATION="./"


main() {
# #######################################################
#
# the heart of the matter, called from below
#
#   parse the arguments
    cmdline "$@"
#   setup the logging
    prep_log
#   verify required arguments
    if [ -z ${DESTINATION+x} ] || [ -z ${SOURCE+x} ];
    then
        usage
        logger_fatal "Both source and destination directories required"
        exit 0
    fi
#   create output directory if needed
    [[ -d "${DESTINATION}" ]] || mkdir -p "${DESTINATION}"
#
    logger_info "START Input $SOURCE, Destination $DESTINATION Trace $TRACELEVEL $(date "+%Y_%m_%d %R:%S")"
#   So files are copied from SOURCE to a directory in /tmp to INBOUND
#       this is to allow graceful termination actions
#       and to avoid problems with folder actions being called before all files are copied
#       NOTE options on the copy will vary by OS -a is OS X
   cp -av "${SOURCE}" /tmp/$$/ | logger_info
   mv -nv /tmp/$$ $DESTINATION  | logger_info
#
# remove the file in /tmp if needed mv will if on the same drive
    [[ -d /tmp/$$ ]] && rm -rv /tmp/$$ | logger_info
    logger_info "DONE  $__SCRIPT $@ $(date "+%Y_%m_%d %R:%S")"
}

usage() {
# explain command line options
  cat << EOF
  USAGE: $0 -h -i input_directory -o output_directory -t trace_level
  or
  USAGE: $0
            --input           input_directory
            --output          output_directory
            --help
            --trace           TRACE DEBUG INFO WARN ERROR DEBUG FATAL
            "OFF
EOF


}

prep_log () {
  # prepare for logging

    # Load log4sh (disabling properties file warning) and clear the default
    # configuration.
    LOG4SH_CONFIGURATION='none' . $__LOGGER_DIRECTORY/log4sh
    log4sh_resetConfiguration

    # Set the global logging level to INFO.
    case "$TRACELEVEL" in
            #translate --gnu-long-options to -g (short options)
            "TRACE")          logger_setLevel TRACE;;
            "DEBUG")          logger_setLevel DEBUG;;
            "INFO")           logger_setLevel INFO;;
            "WARN")           logger_setLevel WARN;;
            "ERROR")          logger_setLevel TRACE;;
            "DEBUG")          logger_setLevel DEBUG;;
            "FATAL")          logger_setLevel FATAL;;
            "OFF")            logger_setLevel OFF;;
    esac
    logger_addAppender stderr
    appender_setType stderr FileAppender
    appender_file_setFile stderr $__LOGFILE
    appender_activateOptions stderr
    logger_debug "Trace $TRACELEVEL"

}

cmdline() {
    # got this idea from here:
    # http://kirk.webfinish.com/2009/10/bash-shell-script-to-use-getopts-with-gnu-style-long-positional-parameters/
    local arg=
    for arg
    do
        local delim=""
        case "$arg" in
            #translate --gnu-long-options to -g (short options)
            --input)          args="${args}-i ";;
            --output)         args="${args}-o ";;
            --help)           args="${args}-h ";;
            --trace)        args="${args}-t ";;
            #pass through anything else
            *) [[ "${arg:0:1}" == "-" ]] || delim="\""
                args="${args}${delim}${arg}${delim} ";;
        esac
    done

    #Reset the positional parameters to the short options
    eval set -- $args

    while getopts "ht:c:i:o:" OPTION
    do
         case $OPTION in
         i)
             readonly SOURCE="$OPTARG"
             ;;
         o)
             readonly DESTINATION="$OPTARG"
             ;;
         t)
             TRACELEVEL=$(echo "$OPTARG" | tr a-z A-Z)
             ;;
         h)
             usage
             exit 0
             ;;
        esac
    done
    return 0
}


# ########################
#
#   Start
#
# ########################
main "$@"



