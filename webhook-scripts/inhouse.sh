#!/bin/bash
# Process a single file from Google Storage
# Parameters:
# $1 - basename of the file (typically the md5sum of the file)

cd /home

PREFIX="Inhouse files"
API=${API:-none}
BUCKET_SRC=${BUCKET_SRC:-dataworkbench-iati}
BUCKET_FB=${BUCKET_FB:-dataworkbench-iatifeedback}
BUCKET_JSON=${BUCKET_JSON:-dataworkbench-json}
BUCKET_SVRL=${BUCKET_SVRL:-dataworkbench-svrl}
VERSION=`grep 'variable name="schemaVersion"' lib/minbuza-rulesets/rules/iati.xslt | cut -f 2 -d \> | cut -f 1 -d \<`
basename=$1

# Try to get the file via our API

mkdir -p /work/space/input

HTTP_STATUS=$(curl -s "$API/iati-files/$BUCKET_SRC/download/$basename.xml" -o "/work/space/input/$basename.xml" -w "%{http_code}")
echo "$PREFIX: retrieved $basename.xml with status $HTTP_STATUS"

# If available:
if [[ $HTTP_STATUS == 200 ]]; then 
  # Make sure we process the file again by removing the target for ant
  rm -f /work/space/dest/"$basename".feedback.xml
  # Run the XML check and the rules
  ant -f build-engine.xml -Dfilemask="$basename" feedback
  
  # Store the result
  
  echo "$PREFIX: store feedback for $basename"
  curl -sS -F "file=@/work/space/dest/$basename.feedback.xml;type=application/xml" "$API/iati-files/$BUCKET_FB/upload"
  
  FILEDATE=$(date -Iseconds -r "/work/space/dest/$basename.feedback.xml")
  
  APIDATA="{\"md5\": \"$basename\", \"feedback-updated\": \"$FILEDATE\", \"feedback-version\": \"$VERSION\"}"
  
  echo "$PREFIX: update iati-datasets for feedback on $basename"
  curl -sS -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' \
  -d "$APIDATA" \
  "$API/iati-datasets/update?where=%7B%22md5%22%3A%22$basename%22%7D"
  
  # Run the JSON conversion
  rm -f /work/space/json/$basename.json
  ant -f build-engine.xml -Dfilemask=$basename json
  
  # Store the result
  echo "$PREFIX: store json for $basename"
  curl -sS -F "file=@/work/space/json/$basename.json;type=application/json" "$API/iati-files/$BUCKET_JSON/upload"
  
  FILEDATE=$(date -Iseconds -r /work/space/json/$basename.json)
  
  APIDATA="{\"md5\": \"$basename\", \"json-updated\": \"$FILEDATE\", \"json-version\": \"$VERSION\"}"
  
  echo "$PREFIX: update iati-datasets for json on $basename"
  curl -sS -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' \
  -d "$APIDATA" \
  "$API/iati-datasets/update?where=%7B%22md5%22%3A%22$basename%22%7D"
  
  # Run the SVRL conversion
  rm -f /work/space/svrl/$basename.svrl
  ant -f build-engine.xml -Dfilemask=$basename svrl
  
  # Store the result
  
  if xmllint --noout /work/space/svrl/$basename.svrl 2> "/dev/null"; then
    echo "$PREFIX: store svrl for $basename"
    curl -sS -F "file=@/work/space/svrl/$basename.svrl;type=application/xml" "$API/iati-files/$BUCKET_SVRL/upload"
  
    FILEDATE=$(date -Iseconds -r /work/space/svrl/$basename.svrl)
  
    APIDATA="{\"md5\": \"$basename\", \"svrl-updated\": \"$FILEDATE\", \"svrl-version\": \"$VERSION\"}"
  
    echo "$PREFIX: update iati-datasets for svrl on $basename"
    curl -sS -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' \
    -d "$APIDATA" \
    "$API/iati-datasets/update?where=%7B%22md5%22%3A%22$basename%22%7D"
  else
    echo "$PREFIX: svrl for $basename is not valid XML"
  fi

fi

# Remove the files from the local node if no second parameter given (allows to keep the artefacts for debugging)
if [[ -z $2 ]]; then
  find /work/space -name "${basename}*" -delete
fi
