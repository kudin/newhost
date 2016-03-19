#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Type hostname (example: test.ru), and press [ENTER]:"
read host 
SERHOME="/home/kudin/webserver"
echo $SERHOME;
cd /etc/apache2/sites-available
cat <<EOF >> "$host.conf"
<VirtualHost *:80>
	ServerName $host
	ServerAlias www.$host
	DocumentRoot $SERHOME/$host
	ServerAdmin webmaster@localhost 
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
<Directory $SERHOME/$host>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
</VirtualHost>
EOF
mkdir "$SERHOME/$host"
cd /etc/apache2/sites-enabled
ln -s "/etc/apache2/sites-available/$host.conf" "$host.conf"
echo "Editing /etc/hosts"
cat <<EOF >> "/etc/hosts"
127.0.0.1       $host
EOF
echo "Set permissions"
chmod -R 777 "$SERHOME/$1"
echo "Restarting Apache2"
service apache2 restart
echo "Finished!"
echo "Local address: http://$host/"
