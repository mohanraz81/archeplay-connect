#!/bin/bash
MYSQLROOTPASSWORD=dbpasssword
MYSQLDATABASE=guacamole_db    
MYSQLUSER=guacamole
MYSQLPASSWORD=guacamole
#yum install docker -y
#usermod -a -G docker ec2-user
#systemctl  start docker
#systemctl status docker
#systemctl enable docker
docker network create guacamole
docker run --net guacamole --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
docker run --net guacamole --name guacamoledb -e MYSQL_ROOT_PASSWORD=$MYSQLROOTPASSWORD -e MYSQL_DATABASE=$MYSQLDATABASE -e MYSQL_USER=$MYSQLUSER -e MYSQL_PASSWORD=$MYSQLPASSWORD -d mysql:5.7
sleep 10s
docker cp initdb.sql guacamoledb:./initdb.sql
sleep 5s
docker run --net guacamole --name guacd -d guacamole/guacd
sleep 10s
docker run --net guacamole --name guacamole  \
    -e MYSQL_HOSTNAME=guacamoledb \
    -e MYSQL_PORT=3306 \
    -e MYSQL_DATABASE=$MYSQLDATABASE  \
    -e MYSQL_USER=$MYSQLUSER    \
    -e MYSQL_PASSWORD=$MYSQLPASSWORD \
    -e GUACD_HOSTNAME=guacd \
    -d -p 80:8080 guacamole/guacamole
sleep 10s
echo "mysql -u root -p$MYSQLROOTPASSWORD guacamole_db < initdb.sql" > installer.sh
docker cp installer.sh guacamoledb:./installer.sh
sleep 4s
docker exec -t guacamoledb sh installer.sh
sleep 4s
docker build -t archeplayapi .
docker run -p 8089:5000 --net guacamole -d --name archeplayapi  \
    -e MYSQL_HOST=guacamoledb \
    -e MYSQL_DATABASE=$MYSQLDATABASE  \
    -e MYSQL_USER=$MYSQLUSER    \
    -e MYSQL_PASSWORD=$MYSQLPASSWORD \
    archeplayapi
    
    