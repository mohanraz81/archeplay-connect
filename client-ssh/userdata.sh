os=DEPENDOS
CONNECTPRIVATEIP=DEPENDCONNECTPRIVATEIP
EMAILID=DEPENDEMAILID
Password=DEPENDPASSWORD
Privatekey=DEPENDPRIVATEKEY
if [ $os == "Ubuntu" ]
then
  apt update
  # apt install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils -y
  # apt install xrdp -y
  # systemctl status xrdp
  # systemctl start xrdp
  # systemctl enable xrdp
  # adduser xrdp ssl-cert
  # systemctl restart xrdp
  # ufw allow 3389
  sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  systemctl restart sshd
  echo ubuntu:$Password  | sudo chpasswd
  # apt install firefox -y
  USERNAME= "ubuntu"
  PRIVATEIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  INSTANCEID=`curl http://169.254.169.254/latest/meta-data/instance-id` 
  sed -i "s/CONNECTPRIVATEIP/$CONNECTPRIVATEIP/g" addtoconnect.sh
  sed -i "s/USERNAME/$USERNAME/g" addtoconnect.sh
  sed -i "s/PRIVATEIP/$PRIVATEIP/g" addtoconnect.sh
  sed -i "s/INSTANCEID/$INSTANCEID/g" addtoconnect.sh
  sed -i "s/EMAILID/$EMAILID/g" addtoconnect.sh
  sed -i "s/PASSWORD/$Password/g" addtoconnect.sh
  sed -i "s/PRIVATEKEY/$Privatekey/g" addtoconnect.sh
  sh -x addtoconnect.sh
  
elif [ $os == "CentOS" ]
then
  # yum install -y epel-release
  # yum install bzip2 -y
  # yum install wget -y
  # yum -y groupinstall -y "Xfce"
  # yum install -y xrdp
  # systemctl enable xrdp
  # systemctl start xrdp
  # echo "xfce4-session" > ~centos/.Xclients
  # chmod a+x ~centos/.Xclients
  sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  systemctl restart sshd
  echo centos:$Password | sudo chpasswd
  # wget http://ftp.mozilla.org/pub/firefox/releases/76.0/linux-x86_64/en-US/firefox-76.0.tar.bz2
  # tar -xvf firefox-76.0.tar.bz2
  # ln -s `pwd`/firefox/firefox /usr/bin/firefox
  USERNAME= "centos"
  PRIVATEIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  INSTANCEID=`curl http://169.254.169.254/latest/meta-data/instance-id` 
  sed -i "s/CONNECTPRIVATEIP/$CONNECTPRIVATEIP/g" addtoconnect.sh
  sed -i "s/USERNAME/$USERNAME/g" addtoconnect.sh
  sed -i "s/PRIVATEIP/$PRIVATEIP/g" addtoconnect.sh
  sed -i "s/INSTANCEID/$INSTANCEID/g" addtoconnect.sh
  sed -i "s/EMAILID/$EMAILID/g" addtoconnect.sh
  sed -i "s/PASSWORD/$Password/g" addtoconnect.sh
  sed -i "s/PRIVATEKEY/$Privatekey/g" addtoconnect.sh
  sh -x addtoconnect.sh
  
  elif [ $os == "AmazonLinux2" ]
then
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  yum-config-manager --enable epel
  # yum install bzip2 -y
  # yum install wget -y
  # yum -y groupinstall -y "Xfce"
  # yum install -y xrdp
  # systemctl enable xrdp
  # systemctl start xrdp
  # echo "xfce4-session" > ~ec2-user/.Xclients
  # chmod a+x ~ec2-user/.Xclients
  sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  systemctl restart sshd
  echo ec2-user:$Password | sudo chpasswd
  # wget http://ftp.mozilla.org/pub/firefox/releases/76.0/linux-x86_64/en-US/firefox-76.0.tar.bz2
  # tar -xvf firefox-76.0.tar.bz2
  # ln -s `pwd`/firefox/firefox /usr/bin/firefox
  USERNAME="ec2-user"
  PRIVATEIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  INSTANCEID=`curl http://169.254.169.254/latest/meta-data/instance-id` 
  sed -i "s/CONNECTPRIVATEIP/$CONNECTPRIVATEIP/g" addtoconnect.sh
  sed -i "s/USERNAME/$USERNAME/g" addtoconnect.sh
  sed -i "s/PRIVATEIP/$PRIVATEIP/g" addtoconnect.sh
  sed -i "s/INSTANCEID/$INSTANCEID/g" addtoconnect.sh
  sed -i "s/EMAILID/$EMAILID/g" addtoconnect.sh
  sed -i "s/PASSWORD/$Password/g" addtoconnect.sh
  sed -i "s/PRIVATEKEY/$Privatekey/g" addtoconnect.sh
  sh -x addtoconnect.sh
fi