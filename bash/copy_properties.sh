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
readonly __INBOUND="/Users/william/Documents/GitHub/PhotoImport/PhotoImport/TestData/Inbound/"
readonly __BKUP_INBOUND="/Volumes/PhotoBkup/Loads/TestData/Inbound/"
readonly prompt_title="Photo Import"
TRACELEVEL="INFO"
DESTINATION="./"

prep_log () {
  # prepare for logging

    # Load log4sh (disabling properties file warning) and clear the default
    # configuration.
#    log4sh_resetConfiguration

    # Set the global logging level to INFO.
    case "$TRACELEVEL" in
            #translate --gnu-long-options to -g (short options)
            "TRACE")          logger_setLevel TRACE;;
            "DEBUG")          logger_setLevel DEBUG;;
            "INFO")           logger_setLevel INFO;;
            "WARN")           logger_setLevel WARN;;
            "ERROR")          logger_setLevel TRACE;;
            "FATAL")          logger_setLevel FATAL;;
            "OFF")            logger_setLevel OFF;;
    esac
#    logger_addAppender stderr
#    appender_setType stderr FileAppender
#    appender_file_setFile stderr $__LOGFILE
#    appender_activateOptions stderr
    logger_debug "Trace $TRACELEVEL"

}

info_box () {
#   popup an info box with OK / CANCEL buttons
#   $1 Dialog text
    our_value=$(osascript <<EOT
    try
        set userCanceled to false
	    tell app "System Events"
		    display dialog "$1" with icon 2 with title "$prompt_title"
		end tell
	on error number -128
        set userCanceled to true
    end
    if userCanceled then
        -- statements to execute when user cancels
        set userCanceled to true
    else
        set userCanceled to false
    end if
EOT
    )
    if [ "$our_value" == "false" ]; then
        echo "false"
    else
        echo "true"
    fi
}

info_prompt () {
#   popup a text entry box
#   $1 Dialog text
#   $2 Default anser
#   $3 Dialog Title
    our_value=$(osascript <<EOT
    set userCanceled to false
    set dialogResult to ""
    set dialogResult to display dialog ¬
        "$1" buttons {"OK"} ¬
        with title "$prompt_title" ¬
        default button "OK" ¬
        giving up after 15 ¬
        default answer ("")
EOT
)
    echo "<$our_value>" | split

}

info_notification () {
    #  simple notification box
    osascript <<END
        display notification "$1" with title "$prompt_title"
END

}


# some are os dependent this is location of log4sh
if [[ "$OSTYPE" =~ ^darwin ]]; then
    readonly LOGGER_DIRECTORY="/Users/william/PycharmProjects/PhotoLoad/log4sh"
    readonly LOGFILE_DIRECTORY="/Users/william/Logs/"
    readonly MEDIA_VOLUME=/Volumes/
    LOG4SH_CONFIGURATION='none' . $LOGGER_DIRECTORY/log4sh
    readonly __CP='cp -av'
    readonly __MV='mv -nv'
elif [[ "$OSTYPE" =~ ^linux ]]; then
    readonly LOGGER_DIRECTORY="/home/william/PycharmProjects/log4sh-1.4.2/src/shell"
    readonly LOGFILE_DIRECTORY="/home/william/Logs/"
    readonly MEDIA_VOLUME="/media/$USER/"
    LOG4SH_CONFIGURATION='none' . "$LOGGER_DIRECTORY/log4sh"
    readonly __CP='cp -av'
    readonly __MV='cp -nupR'
else
    echo "Fatal error unknown OS $__OS"
    exit -1
fi
