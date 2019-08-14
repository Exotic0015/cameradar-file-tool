#!/bin/bash
# Written by Exotic#1124
echo 'If there is an error or nothing happens, make sure you specified a valid file and GOPATH is set.'
TARGETS="`cat $1`"
OUTPUT=$2
IFS=$'\n'
set -f
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
