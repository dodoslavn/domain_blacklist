#!/bin/bash

POM=$(wget -O - https://raw.githubusercontent.com/Turtlecute33/toolz/refs/heads/master/src/data/adblock_data.json 2>/dev/null )

POM=$( echo $POM | jq 'del( ."Error Trackers"."Sentry", ."OEMs"."Apple" )' )

POM=$( echo $POM | jq -r '.. | arrays? | .[]' )

echo "$POM" | sed 's/^/local-zone: "/' | sed 's/$/" always_nxdomain/' > ../tmp/static.conf

echo "############"
echo "### static"
echo " > New static list contains $( cat ../tmp/static.conf | wc -l ) domains"

mv ../tmp/static.conf ../tmp/static.conf.reference
