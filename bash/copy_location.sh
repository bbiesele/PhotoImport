#!/usr/bin/env bash

#  copy_location.sh
#
#  Created by William Biesele on 7/20/18.
#  Copyright © 2018 William Biesele. All rights reserved.

# #######################################################
#
# Globals
readonly __SCRIPT=$( basename $0 )
readonly __CONTROL=$( dirname $0)

. $__CONTROL/copy_properties.sh
#
main() {
# #######################################################
#
# the heart of the matter, called from below
#
#   source the project common
#    . $__CONTROL/copy_properties.sh
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

    move_to_destination
# fini
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
# os dependent move
#
move_to_destination () {
    mkdir "/tmp/$$"
    # the options to cp and mv are os dependent these are defined in the copy_properties.sh file
    logger_info "$__CP $SOURCE to /tmp/$$"
    $__CP "${SOURCE}" /tmp/$$/ | logger_debug
    logger_info "$__MV /tmp/$$ to $DESTINATION"
    $__MV /tmp/$$ ${DESTINATION}  | logger_debug
    if [[ -d /tmp/$$ ]]
    then
        rm -rv /tmp/$$ | logger_trace
    fi
    return 0
}


# ########################
#
#   Start
#
# ########################
main "$@"



