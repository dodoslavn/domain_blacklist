#!/bin/bash

if [ "$( whoami )" != "root" ]
  then
  echo "ERROR: You need to be root!"
  exit 1
  fi

cd "$(dirname "$0")"

. ../conf/config.sh

mkdir -p ../tmp/ 
rm -f ../tmp/*.conf

for S in $LIST;
	do
	echo "############"
	echo "### "$S
	../conf/"$S".sh
	done

cp ../tmp/*.conf /etc/unbound/unbound.conf.d/custom_blacklist.conf.d/

systemctl reload unbound
