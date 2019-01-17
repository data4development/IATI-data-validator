#!/bin/sh
# Process a single file from Google Storage
# Parameters:
# $1 - basename of the file (typically the md5sum of the file)

cd /home 

API=http://validator-api/api
VERSION=`grep 'variable name="schemaVersion"' data-quality/rules/iati.xslt | cut -f 2 -d \> | cut -f 1 -d \<`
basename=$1

# Try to get the file via our API

mkdir -p /workspace/input

curl -X GET "$API/iati-files/download/dataworkbench-iati/$basename.xml" > /workspace/input/$basename.xml 

# If available: 
# Run the XML check and the rules
ant feedback -S -q -Dfilemask=$basename

# Store the result

curl -F "file=@/workspace/dest/$basename.feedback.xml" "$API/iati-files/dataworkbench-iatifeedback/upload"

FILEDATE=$(date -Iseconds -r /workspace/dest/$basename.feedback.xml)

APIDATA="{\"md5\": \"$basename\", \"feedback-updated\": \"$FILEDATE\", \"feedback-version\": \"$VERSION\"}"

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' \
-d "$APIDATA" \
"$API/iati-datasets/upsertWithWhere?where=%7B%22md5%22%3A%22$basename%22%7D"

# Run the JSON conversion

ant json -S -q -Dfilemask=$basename

# Store the result

curl -F "file=@/workspace/json/$basename.json" "$API/iati-files/dataworkbench-json/upload"

FILEDATE=$(date -Iseconds -r /workspace/json/$basename.json)

APIDATA="{\"md5\": \"$basename\", \"json-updated\": \"$FILEDATE\", \"json-version\": \"$VERSION\"}"

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' \
-d "$APIDATA" \
"$API/iati-datasets/upsertWithWhere?where=%7B%22md5%22%3A%22$basename%22%7D"

# Run the SVRL conversion
ant svrl -S -q -Dfilemask=$basename

# Store the result

if xmllint --noout /workspace/svrl/$basename.svrl 2> "/dev/null"; then
  curl -F "file=@/workspace/svrl/$basename.svrl" "$API/iati-files/dataworkbench-svrl/upload"

  FILEDATE=$(date -Iseconds -r /workspace/svrl/$basename.svrl)

  APIDATA="{\"md5\": \"$basename\", \"svrl-updated\": \"$FILEDATE\", \"svrl-version\": \"$VERSION\"}"

  curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' \
  -d "$APIDATA" \
  "$API/iati-datasets/upsertWithWhere?where=%7B%22md5%22%3A%22$basename%22%7D"
fi

# Remove the files from the local node
cd /workspace
rm -rf ${basename}*
