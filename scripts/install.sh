#!/bin/bash

cd "$(dirname "$0")"
cd ..
FOLDER=$(pwd)"/scripts/refresh.sh"
cd - >/dev/null


if [ "$( whoami )" != "root" ]
  then
  echo "ERROR: You need to be root!"
  exit 2
  fi

if ! [ -a "../conf/config.sh" ]
  then
  echo "ERROR: Conf file not found!"
  exit 1
  fi

. ../conf/config.sh

cp ../conf/custom_blacklist.conf /etc/unbound/unbound.conf.d/custom_blacklist.conf
mkdir /etc/unbound/unbound.conf.d/custom_blacklist.conf.d/

. ../conf/custom-dns_blacklist.service.sh
echo "$SERVICE" > /etc/systemd/system/"$SERVICE_NAME".service

. ../conf/custom-dns_blacklist.timer.sh
echo "$TIMER" > /etc/systemd/system/"$SERVICE_NAME".timer

systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME
systemctl status $SERVICE_NAME
