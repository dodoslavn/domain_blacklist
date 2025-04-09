#/bin/bash

cd "$(dirname "$0")"

. ../conf/config.sh

rm ../tmp/*.txt

for S in $LIST;
	do
	echo "############"
	echo "### "$S
	../conf/"$S".sh
	done

cp ../tmp/*.txt /etc/unbound/blacklist/

systemctl reload unbound
