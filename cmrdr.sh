#!/bin/bash
# Written by Exotic#1124
echo 'If there is an error or nothing happens, make sure you specified a valid file and GOPATH is set.'
TARGETS="`cat $1`"
IFS=$'\n'
set -f
for i in $TARGETS; do
    echo 'Attacking '$i'...'
    $GOPATH/bin/cameradar run -t $i
done
