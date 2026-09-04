#!/bin/bash

if [ "$( whoami )" != "root" ]
  then
  echo "ERROR: You need to be root!"
  exit 1
  fi

TEST_DOMAIN="google.com"
if [ $(dig +short $TEST_DOMAIN 2>/dev/null | wc -l) -ne 1 ]
	then
	echo "ERROR: You current DNS doesnt work!"
	exit 0
	fi

ping $TEST_DOMAIN -c 3 1>/dev/null 2>/dev/null
RC=$?
if [ "$RC" -ne 0 ]
	then
	echo "ERROR: You current internet connectivity doesnt work!"
	exit 0
	fi

cd "$(dirname "$0")"

git pull

. ../conf/config.sh

if [ "$(systemctl is-active unbound.service)" = "inactive" ] 
	then
	echo "WARNING: Skipping refresh, unbound is not running!" 
	exit 0
	fi

unbound-checkconf 1>/dev/null 2>/dev/null
RC=$?

if [ "$RC" -ne 0 ]
	then
	echo "ERROR: Found issues in the unbound config!"
	exit 0
	fi

mkdir -p ../tmp/ 
rm -f ../tmp/*.conf

for S in $LIST;
	do
	echo "############"
	echo "### "$S
	../conf/"$S".sh
	done



cp ../tmp/*.conf.reference /etc/unbound/unbound.conf.d/custom_blacklist.conf.d/
cat /etc/unbound/unbound.conf.d/custom_blacklist.conf.d/*.conf.reference | sort | uniq > /etc/unbound/unbound.conf.d/custom_blacklist.conf.d/all_merged.conf
cp ../conf/custom_blacklist.conf /etc/unbound/unbound.conf.d/custom_blacklist.conf

unbound-checkconf 1>/dev/null 2>/dev/null
RC=$?
if [ "$RC" -ne 0 ]
        then
        echo "ERROR: Found issues in Unbound configuration files! Probably caused by custom domain blacklisting service, disabling.."
		echo "# custom domain blacklisting disabled automatically, new configuration didnt work" > /etc/unbound/unbound.conf.d/custom_blacklist.conf	
        exit 0
        fi

systemctl reload unbound
echo 'INFO: New configuration applied'
