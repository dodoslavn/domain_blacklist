#!/bin/bash

LIST=$( wget -O - https://big.oisd.nl/ )

LIST=$(echo "$LIST" | grep ^'||' | sort )

echo " > List contains "$( echo "$LIST" | wc -l )" domains"

echo "$LIST" | sed 's/|//g' | sed 's/\^//' | sed 's/^/local-zone: "/' | sed 's/$/" always_nxdomain/' > ../tmp/oisd.txt
