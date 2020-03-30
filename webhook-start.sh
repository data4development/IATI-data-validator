#!/bin/sh

./update-data.sh

/home/webhook -urlprefix=process -hooks=/home/webhook-scripts/hooks.json -hotreload -verbose