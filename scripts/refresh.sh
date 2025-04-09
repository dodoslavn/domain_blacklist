#!/bin/bash

if [ "$( whoami )" != "root" ]
  then
  echo "ERROR: You need to be root!"
  exit 1
  fi

cd "$(dirname "$0")"

. ../conf/config.sh

mkdir -p ../tmp/ 
rm -f ../tmp/*.txt

for S in $LIST;
	do
	echo "############"
	echo "### "$S
	../conf/"$S".sh
	done

cp ../tmp/*.txt /etc/unbound/blacklist/

systemctl reload unbound
