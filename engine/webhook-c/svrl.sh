#!/bin/sh

cd /home 
mkdir -p /workspace/input

# put the source file into /workspace/input
tfile=$(mktemp /tmp/XXXXXXXXX)
wget -q -O $tfile $1
md5sum=$(md5sum $tfile | cut -d \  -f 1) 
mv $tfile /workspace/input/$md5sum.xml

ant svrl -S -q
cat /workspace/svrl/$md5sum.svrl
