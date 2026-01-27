#!/bin/bash

DOMAINS=$(wget -O - https://oisd.nl/includedlists/big/0 2>/dev/null )
DOMAINS=$(echo "$DOMAINS" | grep 'Included in OISD' | cut -d'"' -f4 )

echo " > Downloading lists from $( echo "$DOMAINS" | wc -l ) OISD sources"

true > ../tmp/oisd.raw
for S in $( echo $DOMAINS )
        do
        echo -n .
        wget -O - $S >> ../tmp/oisd.raw 2>/dev/null
        done
echo

cat ../tmp/oisd.raw | sed 's/<[^>]*>//g' | grep -v ^http | grep '\.' > ../tmp/oisd.clean

sort ../tmp/oisd.clean -o ../tmp/oisd.sorted
uniq ../tmp/oisd.sorted > ../tmp/oisd.conf

sed 's/^/local-zone: "/' -i ../tmp/oisd.conf
sed 's/$/" always_nxdomain/' -i ../tmp/oisd.conf
echo " > New list contains "$( cat ../tmp/oisd.conf | wc -l ) domains
