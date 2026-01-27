#!/bin/bash

LIST=$( wget -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts 2>/dev/null )

#prepare
LIST=$( echo "$LIST" | grep '0.0.0.0' | sed 's/^0\.0\.0\.0\ //' | grep -v \# | grep -v ^$ | sort )

#data cleanup
LIST=$( echo "$LIST" | grep -v '0.0.0.0')

echo " > New list contains "$( echo "$LIST" | wc -l )" domains"

echo "$LIST" | sed 's/^/local-zone: "/' | sed 's/$/" always_nxdomain/' > ../tmp/stevenblack.conf
