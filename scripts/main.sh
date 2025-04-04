#/bin/bash

source ../conf/config.sh

rm ../tmp/*.txt

for S in $LIST;
	do
	echo "############"
	echo "### "$S
	../conf/"$S".sh
	done

sudo cp ../tmp/*.txt /etc/unbound/blacklist/
