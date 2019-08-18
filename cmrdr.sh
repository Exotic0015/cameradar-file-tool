#!/bin/bash
exitfn () {
    trap SIGINT
    echo -e '\nInterrupt detected!\nExiting...'
    if [[ $OUTPUT != "" ]]; then
        awk "!/  > Perform failed: curl: Failure when receiving data from the peer/" $OUTPUT > temp && mv temp $OUTPUT
        awk "!/  > Perform failed: curl: Couldn't connect to server/" $OUTPUT > temp && mv temp $OUTPUT
        awk "!/  > Perform failed: curl: Timeout was reached/" $OUTPUT > temp && mv temp $OUTPUT
    fi
    exit 1
}
trap "exitfn" INT
OPTIND=1
LEVEL=${LEVEL:-3}
OUTPUT=${OUTPUT:-""}
IFS=$'\n'
set -f
help() {
    echo "Usage: $0 [Options]"
    echo " req=required, opt=optional"
    echo "MAIN OPTIONS"
    echo " -f <iplist file location>: Specify an IP list file location [req]"
    echo " -o <output file location>: Specify a location for a newly created output file [opt]"
    echo " -s <speed number>: Specify a speed number (0-5, default=3) [opt]"
    echo "EXTRAS"
    echo " -h: Display this help message"
}
unset name
while getopts ":f:o:s:h" argument; do
    case "${argument}" in
        f)
            TARGETS="`cat ${OPTARG}`"
            ;;
        o)
            OUTPUT=${OPTARG}
            ;;
        s)
            LEVEL=${OPTARG}
            ;;
        h)
            help
            exit 1
            ;;
        ?)
            echo "Usage: $0 [Options]" >&2
            echo -e "\nFor a full list of commands please use $0 -h"
            exit 1
            ;;
    esac
done
if [ -z "$name" ]
then
    echo "Usage: $0 [Options]" >&2
    echo -e "\nFor a full list of commands please use $0 -h"
    exit 1
fi
shift $((OPTIND-1))
echo 'If there is an error or nothing happens, make sure you specified a valid ip list file and GOPATH is set.'
if [[ $OUTPUT != "" ]]; then
    echo -n "" > $OUTPUT
    for i in $TARGETS; do
       echo 'Attacking '$i' with level '$LEVEL' speed...'
       $GOPATH/bin/cameradar run -t $i -s $LEVEL |& tee -a $OUTPUT
       awk "!/  > Perform failed: curl: Failure when receiving data from the peer/" $OUTPUT > temp && mv temp $OUTPUT
       awk "!/  > Perform failed: curl: Couldn't connect to server/" $OUTPUT > temp && mv temp $OUTPUT
       awk "!/  > Perform failed: curl: Timeout was reached/" $OUTPUT > temp && mv temp $OUTPUT
    done
else
    for i in $TARGETS; do
        echo 'Attacking '$i' with level '$LEVEL' speed...'
       $GOPATH/bin/cameradar run -t $i -s $LEVEL
    done
fi
trap SIGINT