# Cameradar File Tool

### Requirements
[Cameradar](https://github.com/ullaakut/cameradar)

### Usage
```
./cmrdr.sh [Options]
```

### Options
```
MAIN OPTIONS
    -f <iplist file location>: Specify an IP list file location [required]
    -o <output file location>: Specify a location for a newly created output file [optional]
    -s <speed value>: Specify a speed value (0-5, default=4) [optional]
    -c <json file path>: Specify credentials json location (default=${GOPATH}/src/github.com/ullaakut/cameradar/dictionaries/credentials.json) [optional]
    -r <json file path>: Specify routes json location (default=${GOPATH}/src/github.com/ullaakut/cameradar/dictionaries/routes) [optional]
EXTRAS
    -d: Enable debug logs
    -h: Display the help message
```

### Example IP list file content
```
123.456.789.123
345.567.978.098
123.435.578.890
556.789.234.567
421.456.768.423
432.543.435.213
312.545.654.456
```
