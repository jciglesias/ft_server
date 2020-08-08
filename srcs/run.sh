# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    run.sh                                             :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jiglesia <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/26 16:54:41 by jiglesia          #+#    #+#              #
#    Updated: 2020/08/08 22:12:45 by jiglesia         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


#UPDATE & INSTALL PACKAGES
apt-get update
apt-get upgrade -y
apt-get -y install mariadb-server wget php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip php7.3-soap php7.3-imap php-mysql libnss3-tools nginx

#Initial setup
service mysql start
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

#NGINX SETUP
cd
mkdir -p /var/www/html/mipagina && touch /var/www/html/mipagina/index.php
echo "<?php phpinfo(); ?>" >> /var/www/html/mipagina/index.php
cp /tmp/nginx-conf /etc/nginx/sites-available/mipagina
ln -s /etc/nginx/sites-available/mipagina /etc/nginx/sites-enabled/mipagina
rm -rf /etc/nginx/sites-enabled/default

#SSL SETUP
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/mipagina.pem -keyout /etc/nginx/ssl/mipagina.key -subj "/C=EN/ST=Paris/L=Paris/O=42 School/OU=jiglesia/CN=172.17.0.2/"

#MYSQL SETUP
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password
echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root --skip-password

#WORDPRESS INSTALL
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/html/mipagina
mv /tmp/wp-config.php /var/www/html/mipagina/wordpress

#PHPMYADMIN INSTALL
mkdir /var/www/html/mipagina/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/mipagina/phpmyadmin
cp /tmp/phpmyadmin.inc.php /var/www/html/mipagina/phpmyadmin/config.inc.php

#SERVICE STARTER
service php7.3-fpm start
service nginx start
bash
