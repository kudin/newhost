#!/bin/bash
SERHOME="/home/kudin/webserver"
echo $SERHOME;
cd /etc/apache2/sites-available
cat <<EOF >> "$1.conf"
<VirtualHost *:80>
	ServerName $1
	ServerAlias www.$1
	DocumentRoot $SERHOME/$1
	ServerAdmin webmaster@localhost 
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
<Directory $SERHOME/$1>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
</VirtualHost>
EOF
mkdir "$SERHOME/$1"
cd /etc/apache2/sites-enabled
ln -s "/etc/apache2/sites-available/$1.conf" "$1.conf"
echo "Editing /etc/hosts"
cat <<EOF >> "/etc/hosts"
127.0.0.1       $1
EOF
echo "Set permissions"
chmod -R 777 "$SERHOME/$1"
echo "Restarting Apache2"
service apache2 restart
echo "Finished!"
echo "Local address: http://$1/"
