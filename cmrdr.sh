#!/bin/bash
exitfn () {
    trap SIGINT
    echo -e '\nInterrupt detected!\nExiting...'
    if [[ $OUTPUT != "" ]]; then
        cleanup
    fi
    exit 1
}
trap "exitfn" INT
OPTIND=1
LEVEL=3
CREDS="${GOPATH}/src/github.com/ullaakut/cameradar/dictionaries/credentials.json"
ROUTES="${GOPATH}/src/github.com/ullaakut/cameradar/dictionaries/routes"
OUTPUT=""
DEBUG=false
IFS=$'\n'
set -f
help() {
    echo "Usage: $0 [Options]"
    echo " req=required, opt=optional"
    echo "MAIN OPTIONS"
    echo " -f <iplist file path>: Specify an IP list file location [req]"
    echo " -o <output file path>: Specify a location for a newly created output file [opt]"
    echo " -s <speed number>: Specify a speed number (0-5, default=3) [opt]"
    echo " -c <json file path>: Specify credentials json location (default=${GOPATH}/src/github.com/ullaakut/cameradar/dictionaries/credentials.json) [opt]"
    echo " -r <json file path>: Specify routes json location (default=${GOPATH}/src/github.com/ullaakut/cameradar/dictionaries/routes) [opt]"
    echo "EXTRAS"
    echo " -d: Enable debug logs"
    echo " -h: Display this help message"
}
cleanup() {
    cat $OUTPUT | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > temp && mv temp $OUTPUT
}
if [[ ! $@ =~ ^\-.+ ]]; then
    echo "Usage: $0 [Options]" >&2
    echo -e "\nFor a full list of commands please use $0 -h"
    exit 1
fi
while getopts ":f:o:s:hc:dr:" argument; do
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
        c)
            CREDS=${OPTARG}
            ;;
        d)
            DEBUG=true
            ;;
        r)
            ROUTES=${OPTARG}
            ;;
        ?)
            echo "Usage: $0 [Options]" >&2
            echo -e "\nFor a full list of commands please use $0 -h"
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))
echo 'If there is an error or nothing happens, make sure you specified a valid ip list file and GOPATH is set.'
if [[ $OUTPUT != "" ]]; then
    echo -n "" > $OUTPUT
    for i in $TARGETS; do
       echo 'Attacking '$i' with level '$LEVEL' speed...'
       unbuffer $GOPATH/bin/cameradar run -t $i -s $LEVEL -c $CREDS -d $DEBUG -r $ROUTES |& tee -a $OUTPUT
       cleanup
    done
else
    for i in $TARGETS; do
        echo 'Attacking '$i' with level '$LEVEL' speed...'
       $GOPATH/bin/cameradar run -t $i -s $LEVEL -c $CREDS -d $DEBUG -r $ROUTES
    done
fi
trap SIGINT