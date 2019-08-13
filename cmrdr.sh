#!/bin/bash
LOCATION=$1
TARGETS="`cat $LOCATION | tr '\n' ','`"
$GOPATH/bin/cameradar -t ${TARGETS::-1}