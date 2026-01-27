#!/bin/bash


POM=$(wget -O - https://raw.githubusercontent.com/Turtlecute33/toolz/refs/heads/master/src/data/adblock_data.json )

POM=$( echo $POM | jq 'del( ."Error Trackers"."Sentry", ."OEMs"."Apple" )' )

POM=$( echo $POM | jq -r '.. | arrays? | .[]' )

echo $POM | sed 's/^/local-zone: "/' | sed 's/$/" always_nxdomain/' > /etc/unbound/unbound.conf.d/custom_blacklist.conf.d/static.conf
