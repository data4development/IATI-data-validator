#!/bin/sh

cd /home 
mkdir -p /workspace/input

# put the source file into /workspace/input
tfile=$(mktemp /tmp/XXXXXXXXX)
wget -q -O $tfile $2
md5sum=$(md5sum $tfile | cut -d \  -f 1) 
mv $tfile /workspace/input/$md5sum.xml

case $1 in
  svrl)
    ant svrl -S -q
    cat /workspace/svrl/$md5sum.svrl
    # put the SVRL version in its place
    # update the 
    break;;
  json)
    ant json -S -q
    # put the JSON version in its place
    cat /workspace/json/$md5sum.json
    break;;
  *)
    ant feedback -S -q
    cat /workspace/dest/$md5sum.feedback.xml
esac
