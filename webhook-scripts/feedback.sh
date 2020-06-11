#!/bin/sh

# taken an expression from https://mathiasbynens.be/demo/url-regex
URLREGEX='^(https?|ftp)://[^[:space:]/$.?#].[^[:space:]]*$'

# determine which output format to use
case $2 in
  svrl)
    target=svrl
    resultdir=svrl
    resultext=svrl
    break;;
  json)
    target=json
    resultdir=json
    resultext=json
    break;;
  *)
    target=feedback
    resultdir=dest
    resultext=feedback.xml
esac

if echo "$1" | grep -Eq "$URLREGEX"
then
  cd /home 
  mkdir -p /work/space/input
  
  # put the source file into /work/space/input using the md5 as name
  tfile=$(mktemp /tmp/XXXXXXXXX)
  wget -q -O $tfile $1
  md5sum=$(md5sum $tfile | cut -d \  -f 1) 
  mv $tfile /work/space/input/$md5sum.xml
  
  # generate and return the svrl output
  ant -f build-engine.xml full-$target -S -q -Dfilemask=$md5sum
  cat /work/space/$resultdir/$md5sum.$resultext

else
  cat /home/webhook-scripts/not-url.$resultext
fi
