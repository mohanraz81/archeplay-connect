#!/bin/bash
yum -y install git
git clone https://github.com/mohanraz81/archeplay-connect.git
cd archeplay-connect
MYSQLROOTPASSWORD=
MYSQLDATABASE=
MYSQLUSER=
MYSQLPASSWORD=
sed -i "s/aprootpassword/$MYSQLROOTPASSWORD/g" startup.sh
sed -i "s/apdbname/$MYSQLDATABASE/g" startup.sh
sed -i "s/apdbname/$MYSQLUSER/g" startup.sh
sed -i "s/apdbpassword/$MYSQLPASSWORD/g" startup.sh
sh -x ./startup.sh