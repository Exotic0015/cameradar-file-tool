#!/bin/bash
# Written by Exotic#1124
echo 'If there is an error or nothing happens, make sure you specified a valid file and GOPATH is set.'
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
# Variables
OPTIND=1
OUTPUT=""
IFS=$'\n'
set -f
# Code
while getopts ":f:o:" argument; do
    case "${argument}" in
        f)
            TARGETS="`cat ${OPTARG}`"
            ;;
        o)
            OUTPUT=${OPTARG}
            ;;
        ?)
            echo "Usage: $0 [-f iplist_filename] [-o output_filename (optional)]" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))
if [[ $OUTPUT != "" ]]; then
    echo -n "" > $OUTPUT
    for i in $TARGETS; do
       echo 'Attacking '$i'...'
       $GOPATH/bin/cameradar run -t $i |& tee -a $OUTPUT
       awk "!/  > Perform failed: curl: Failure when receiving data from the peer/" $OUTPUT > temp && mv temp $OUTPUT
       awk "!/  > Perform failed: curl: Couldn't connect to server/" $OUTPUT > temp && mv temp $OUTPUT
       awk "!/  > Perform failed: curl: Timeout was reached/" $OUTPUT > temp && mv temp $OUTPUT
    done
else
    for i in $TARGETS; do
        echo 'Attacking '$i'...'
       $GOPATH/bin/cameradar run -t $i
    done
fi
# End
trap SIGINT