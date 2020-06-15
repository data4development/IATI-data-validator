#!/bin/bash
# Get the latest versions of data files

API=${API:=none}

if [[ "$API" != "none" ]]; then
  BUCKET_FILES=${BUCKET_FILES:=dataworkbench-files-staging}
  BUCKET_FILES_DIR=${BUCKET_FILES_DIR:=dwb}

  for FILE in known-activities.txt known-orgid-prefixes.xml known-publishers.xml; do
    curl -sS -o $FILE $API/iati-files/$BUCKET_FILES/download/${BUCKET_FILES_DIR}_$FILE
    if [[ $(wc -l <$FILE) -gt 1000 ]]; then
      mv $FILE lib/minbuza-rulesets/var
    else
      rm $FILE
    fi
  done
fi
