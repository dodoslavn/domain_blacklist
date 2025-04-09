#!/bin/bash

LIST=$( wget -O - https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt )

LIST=$( echo "$LIST" | grep '0.0.0.0' | sed 's/0\.0\.0\.0\ //' | sort )

echo " > List contains "$(echo "$LIST" | wc -l)" domains"

echo "$LIST" | sed 's/^/local-zone: "/' | sed 's/$/" always_nxdomain/' > ../tmp/notracking.txt
