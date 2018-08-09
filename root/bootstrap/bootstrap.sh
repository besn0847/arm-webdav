#!/bin/ash

#make folders
mkdir -p \
        /config/apache/site-confs \
        /config/keys \
        /config/log/apache \
        /config/www \
        /config/log/php \
        /run/apache2

#clear old pid
[[ -e /run/apache2/httpd.pid ]] && \
        rm /run/apache2/httpd.pid

#copy config files
[[ ! -f /config/apache/site-confs/default.conf ]] && \
        cp /bootstrap/defaults/default.conf /config/apache/site-confs/default.conf
[[ ! -f /config/apache/httpd.conf ]] && \
        cp /bootstrap/defaults/httpd.conf /config/apache/httpd.conf
[[ $(find /config/www -type f | wc -l) -eq 0 ]] && \
        cp /bootstrap/defaults/index.html /config/www/index.html
[[ ! -f /config/apache/user.passwd ]] && \
        cp /bootstrap/defaults/user.passwd /config/apache/user.passwd

cp /config/apache/httpd.conf /etc/apache2/httpd.conf

#make symlinks
if [ ! -e /config/www/logs -o /config/www/modules -o /config/www/run ]; then
ln -sf /var/log/apache2 /config/www/logs
ln -sf /usr/lib/apache2 /config/www/modules
ln -sf /run/apache2 /config/www/run
fi

#fix timezone in php.ini
sed -i "s#;date.timezone =.*#date.timezone = $TZ#g" /etc/php7/php.ini
#fix php-fpm log location
sed -i "s#;error_log = log/php7/error.log.*#error_log = /config/log/php/error.log#g" /etc/php7/php-fpm.conf
#fix php-fpm user
sed -i "s#user = nobody.*#user = apache#g" /etc/php7/php-fpm.d/www.conf
sed -i "s#group = nobody.*#group = apache#g" /etc/php7/php-fpm.d/www.conf

#permissions
chown -R apache:apache \
        /config \
        /run/apache2
chmod -R g+w \
        /config/apache /config/www
chmod -R 644 /etc/logrotate.d

SUBJECT="//C=US/ST=CA/L=Carlsbad/O=Linuxserver.io/OU=LSIO Server/CN=*"
if [[ -f /config/keys/cert.key && -f /config/keys/cert.crt ]]; then
	echo "using keys found in /config/keys"
else
	echo "generating self-signed keys in /config/keys, you can replace these with your own keys if required"
	openssl req -new -x509 -days 3650 -nodes -out /config/keys/cert.crt -keyout /config/keys/cert.key -subj "$SUBJECT"
	chown apache:apache /config/keys/ -R
fi

chown apache:apache /config/apache/user.passwd
chmod 640 /config/apache/user.passwd
