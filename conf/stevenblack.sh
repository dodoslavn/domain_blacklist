#!/bin/bash

LIST=$( wget -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts  )

#prepare
LIST=$( echo "$LIST" | grep '0.0.0.0' | sed 's/^0\.0\.0\.0\ //' | grep -v \# | grep -v ^$ | sort )

#data cleanup
LIST=$( echo "$LIST" | grep -v '0.0.0.0')

echo " > List contains "$( echo "$LIST" | wc -l )" domains"

echo "$LIST" | sed 's/^/local-zone: "/' | sed 's/$/" always_nxdomain/' > ../tmp/stevenblack.txt
