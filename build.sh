#!/usr/bin/env bash

# Remove CD-ROM from APT sources
nano /etc/apt/sources.list

apt-get update
apt-get install -y build-essential module-assistant
module-assistant prepare
apt-get install -y openssh-server zerofree sudo

# Add vagrant user to sudoers
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add insecure SSH key for vagrant user
mkdir /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
mv vagrant.pub authorized_keys
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Add insecure SSH key for root user
mkdir /root/.ssh
cd /root/.ssh
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
mv vagrant.pub authorized_keys
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/authorized_keys
chown -R root:root /root/.ssh

# Modify SSH config for speed
echo "UseDNS no" >> /etc/ssh/sshd_config

# Install common dependencies
apt-get install -y git zip unzip keychain nfs-common portmap

# Install node, npm (1.4.28)
apt-get install -y curl lsb-release
curl -sL https://deb.nodesource.com/setup | bash -
apt-get install -y nodejs npm

# Install latest npm
curl -L https://npmjs.com/install.sh | sh

# Install grunt
npm install -g grunt-cli bower

# Install apache2
apt-get install -y apache2
a2enmod deflate
a2enmod filter
a2enmod headers
a2enmod mime
a2enmod rewrite
service apache2 restart

mkdir -p /var/www/domains
# mkdir -p /var/www/logs
# mkdir -p /var/www/html

# cp /etc/apache2/sites-available/default /etc/apache2/sites-available/default.backup
# cp /etc/apache2/sites-available/default-ssl /etc/apache2/sites-available/default-ssl.backup
# cp -f ${HOME}/vagrant-lamp/etc/apache2/sites-available/default /etc/apache2/sites-available/default
# cp -f ${HOME}/vagrant-lamp/etc/apache2/sites-available/default-ssl /etc/apache2/sites-available/default-ssl

# Install mysql
apt-get install -y mysql-server
cp /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
cp -f ${HOME}/vagrant-lamp/etc/mysql/my.cnf /etc/mysql/my.cnf

# Clear innodb logfiles and restart mysql to apply config
service mysql stop
mkdir -p "/var/lib/mysql"
for TMP in `ls "/var/lib/mysql" | grep -i '^ib_logfile'`
do
  rm -f "/var/lib/mysql/${TMP}"
done
service mysql start

# Install php
apt-get install -y php5 php5-mysql php-pear php5-gd php5-curl php5-sqlite sqlite3 libpcre3-dev php5-dev graphviz

# Install apc, xhprof
pecl install apc
pecl install xhprof-beta
pecl install zendopcache

cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.backup
cp /etc/php5/cli/php.ini /etc/php5/cli/php.ini.backup
cp -f ${HOME}/vagrant-lamp/etc/php5/apache2/php.ini /etc/php5/apache2/php.ini
cp -f ${HOME}/vagrant-lamp/etc/php5/cli/php.ini /etc/php5/cli/php.ini
service apache2 restart

# Install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install drush 7
# composer global require drush/drush:dev-master
# sed -i '1i export PATH="$HOME/.composer/vendor/bin:$PATH"' $HOME/.bashrc
# source $HOME/.bashrc

# Install drush 6
pear config-create ${HOME} ${HOME}/.pearrc
pear install -o PEAR
echo "export PHP_PEAR_PHP_BIN=/usr/bin/php" >> ${HOME}/.bash_profile
echo "export PATH=${HOME}/pear:/usr/bin:${PATH}" >> ${HOME}/.bash_profile
. ${HOME}/.bash_profile
pear channel-discover pear.drush.org
pear install drush/drush
drush status

# Optional. If `drush status` reports an error, then it might be necessary to create ${HOME}/.drush/drush.ini
# cd ${HOME}/.drush
# wget https://raw.githubusercontent.com/drush-ops/drush/6.x/examples/example.drush.ini -O drush.ini
# nano drush.ini

# Install phpmyadmin
# cd /var/www/html
# rm -f phpMyAdmin-4.4.3-english.tar.gz
# rm -fr phpmyadmin
# wget http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/4.4.3/phpMyAdmin-4.4.3-english.tar.gz/download -O phpMyAdmin-4.4.3-english.tar.gz
# tar -xzvf phpMyAdmin-4.4.3-english.tar.gz
# mv phpMyAdmin-4.4.3-english phpmyadmin

# Remove VirtualBox guest additions installed by Debian
apt-get purge virtualbox-ose-guest* xserver*
apt-get autoremove
apt-get install -y linux-headers-$(uname -r)

# Mount CD and install VirtualBox guest additions
mount /media/cdrom
sh /media/cdrom/VBoxLinuxAdditions.run
umount /media/cdrom

shutdown -h now
