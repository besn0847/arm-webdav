#!/bin/ash

if [ ! -f /config/.bootstrapped_webdav ]
then
	/bootstrap/bootstrap.sh
	echo 1 > /config/.bootstrapped_webdav
fi

while(true)
do
	/usr/sbin/apachectl -D FOREGROUND
	sleep 5
done
