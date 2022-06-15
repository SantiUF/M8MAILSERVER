#!/bin/bash

#Introducimos el hostname y hacemos preparaciones
sudo hostnamectl set-hostname mailserver
sudo rm /etc/hosts
echo "127.0.0.1 localhost" | sudo tee /etc/hosts
echo "127.0.0.1 mailserver.jdasu.cf mailserver" | sudo tee -a /etc/hosts
sudo apt-get update
sudo apt-get upgrade -y

#Instalamos apache2
sudo apt-get install apache2 -y

#Descargamos script de creación de debconfs para la instalación de postfix
sudo wget https://raw.githubusercontent.com/SantiUF/M8MAILSERVER/postfixconf.sh
sudo chmod 755 postfixconf.sh
sudo sh postfixconf.sh

#Creamos los usuarios para el correo e instalamos postfix
useradd -m -s /bin/bash santy
echo "santy:1234abcd" | chpasswd
useradd -m -s /bin/bash jdasu
echo "santy:1234abcd" | chpasswd
sudo apt-get install -q postfix -y
sudo postconf home_mailbox=Maildir/

#Instalamos Dovecot
sudo apt-get install dovecot-core dovecot-imapd dovecot-pop3d -y
sudo wget https://raw.githubusercontent.com/SantiUF/M8MAILSERVER/10-auth.conf
sudo wget https://raw.githubusercontent.com/SantiUF/M8MAILSERVER/10-mail.conf
sudo cp 10-mail.conf /etc/dovecot/conf.d/10-mail.conf
sudo cp 10-auth.conf /etc/dovecot/conf.d/10-auth.conf

#mysql
sudo apt-get install mysql-server -y
sudo apt-get install mysql-server-core-8.0 -y
sudo apt-get install mysql-server-client-8.0 -y
#mysql -e
sudo mysql -u root -p
sudo mysql -e "CREATE DATABASE ROUNDCUBE;"
sudo mysql -e "CREATE USER roundcube@localhost IDENTIFIED BY 'Armario23*';"
sudo mysql -e "GRANT ALL PRIVILEGES on ROUNDCUBE.* TO roundcube@localhost;"
sudo mysql -e "FLUSH PRIVILEGES;"
# Todo lo del roundcube
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mysql php7.4-cli php-pear php7.4-opcache php7.4-gd php7.4-curl php7.4-cli php7.4-imap php7.4-mbstring php7.4-intl php7.4-soap php7.4-ldap php-imagick php7.4-xmlrpc php7.4-xml php7.4-zip -y
sudo pear install Auth_SASL2 Net_SMTP Net_IDNA2-0.1.1 Mail_mime Mail_mimeDecode
wget https://github.com/roundcube/roundcubemail/releases/download/1.5.2/roundcubemail-1.5.2-complete.tar.gz
tar -xvzf roundcubemail-1.5.2-complete.tar.gz
mv roundcubemail-1.5.2 /var/www/roundcube
chown -R www-data:www-data /var/www/roundcube/
sudo wget https://raw.githubusercontent.com/SantiUF/M8MAILSERVER/004-roundcube.conf
sudo mv 004-roundcube.conf /etc/apache2/sites-available/004-roundcube.conf
sudo a2dissite 000-default.conf
sudo a2ensite 004-roundcube.conf
sudo a2enmod rewrite
#systemctl
sudo systemctl restart apache2
sudo systemctl restart postfix
sudo systemctl restart dovecot
