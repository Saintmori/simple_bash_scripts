#! /bin/bash

#this script will install wordpress on centos 7.
clear
#------------------------------------------------------------------------------
#Greeting and let the user know what this script is design for.
#-----------------------------------------------------------------------------
echo -e "\033[1;3m hello dear \033[0m \033[32;47m $USER \033[0m. This program will install \033[32;47m LAMP \033[0m and prepare everything to run your wordpress;Let's begin!"
sleep 5
#-----------------------------------------------------------------------------
#first we need to install apache and start it up......
#-----------------------------------------------------------------------------
which httpd &>/dev/null || yum -y install httpd
systemctl start httpd && systemctl enable httpd
#-----------------------------------------------------------------------------
#now it is time to install php on the system....
#-----------------------------------------------------------------------------
php_check () {
php -v &>/dev/null || yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm; yum -y install yum-utils &>/dev/null 
}
php_check
#-----------------------------------------------------------------------------
#let the user know that now we need to update yum so it will take a while!
#-----------------------------------------------------------------------------
php -v &>/dev/null || yum-config-manager --enable remi-php74; yum makecache &>/dev/null
clear
echo -e "\033[;32;47m updating yum.... Please be patient! \033[0m "
sleep 8
yum -y update
#-----------------------------------------------------------------------------
#this command will install php and all its dependencies ...
#-----------------------------------------------------------------------------
php -v &>/dev/null || yum -y install php php-cli; yum -y install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json 
systemctl restart httpd
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#-----------------------------------------------------------------------------
#now it is time to download wordpress zip file and install wordpress ...
#-----------------------------------------------------------------------------
which wget || yum -y install wget
cd ~
find / -name latest.tar.gz 
if [[ $? != 0 ]]; then wget https://wordpress.org/latest.tar.gz 
fi
tar -xzf latest.tar.gz
mv wordpress/* /var/www/html/
chown -R apache:apache /var/www/html
#----------------------------------------------------------------------------
#changing selinx configuration file so apache can serve wordpress...
#-----------------------------------------------------------------------------
systemctl status mariadb &>/dev/null || curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
bash mariadb_repo_setup --mariadb-server-version=10.5 
yum makecache
yum -y install MariaDB-server MariaDB-client MariaDB-backup
systemctl start mariadb && systemctl enable mariadb
sleep 5
clear
echo -e "\033[1;3m  mariadb is installed now let's set up mariadb \033[0m "
#-----------------------------------------------------------------------------
#now seting up the secure mariadb installation...
#-----------------------------------------------------------------------------

cat > mysql_secure_installation << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF
echo " now please answer to these questions!"
echo " rememebr you'll need this info for login into your wordpress page"
sleep 4
read -p 'please name your database: ' DBNAME
read -p 'please write a name for the user: ' DBUSER
read -sp 'please set a password for the user: ' PASSUSER

mysql -u root -e "CREATE DATABASE $DBNAME";
mysql -u root -e "CREATE USER ${DBUSER}@localhost IDENTIFIED BY '$PASSUSER'";
mysql -u root -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO $DBUSER@localhost IDENTIFIED BY '$PASSUSER'";
mysql -u root -e "FLUSH PRIVILEGES";
mysql -u root -e "exit";
clear
sleep 4
echo -e "\033[1;3m"
echo "This is your IP address `ifconfig | head -n 2 | grep -i inet | awk '{print $2}'`"
echo " you can now paste it to your browser and log in to your wordpress installation page"
echo " for that your system will be rebooted "
echo " bye , happy browsing 😀"😉
echo -e "\033[0m"
init 6


reboot










