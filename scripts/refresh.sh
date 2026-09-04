#!/bin/bash

if [ "$( whoami )" != "root" ]
  then
  echo "ERROR: You need to be root!"
  exit 1
  fi

cd "$(dirname "$0")"

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


cp ../tmp/*.conf /etc/unbound/unbound.conf.d/custom_blacklist.conf.d/
echo '# Do NOT edit - config file managed by blacklisting service
server:
        include: /etc/unbound/unbound.conf.d/custom_blacklist.conf.d/*.conf' > /etc/unbound/unbound.conf.d/custom_blacklist.conf

unbound-checkconf 1>/dev/null 2>/dev/null
RC=$?
if [ "$RC" -ne 0 ]
        then
        echo "ERROR: Found issues in Unbound configuration files! Probably caused by custom domain blacklisting service, reverting.."
	echo "# custom blacklisting disabled automatically, new configuration didnt work" > /etc/unbound/unbound.conf.d/custom_blacklist.conf	
        exit 0
        fi

systemctl reload unbound
echo 'INFO: New configuration applied'
