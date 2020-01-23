#!/bin/bash
# Get the latest versions of data files

API=${API:=http://validator-api/api/v1}

BUCKET_FILES=${BUCKET_FILES:=dataworkbench-files-staging}
BUCKET_FILES_DIR=${BUCKET_FILES_DIR:=dwb}

for FILE in known-activities.txt known-prefixes.xml known-publishers.xml; do
  curl -sS -o $FILE $API/iati-files/$BUCKET_FILES/download/${BUCKET_FILES_DIR}_$FILE
  if [[ $(wc -l <$FILE) -gt 1000 ]]; then
    mv $FILE data-quality/lib/
  else
    rm $FILE
  fi
done
