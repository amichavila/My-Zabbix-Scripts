#!/bin/bash
#
# Run this script in your zabbix client
#    created by Lucho - <luislopez72@gmail.com>
##########

# Variables del Script
REPO="deb http://backports.debian.org/debian-backports lenny-backports main"
LISTAREPOS="/etc/apt/sources.list"
ZabbixServer="A.B.C.D"
HostName=$1


#####################################################
###  Codigo principal del script
#####################################################

if [ `id -u` != 0 ] ;
  then
     echo "You need logged as root..."
     echo "Try su or su -"
     exit 1
fi


# Verificar que los datos son correctos
clear
echo "--- Please, check this data ---"
echo "Server: $ZabbixServer"
echo "HostName: $HostName"
echo "-------------------------------" 
echo
echo ">> Press ENTER to continue or CTRL+C to exit"
   read Esperar



echo "Verifying repos list..."
if grep ^"$REPO" $LISTAREPOS ;
  then
     echo "This repo already exist."
  else
     echo "Adding $REPO..."
     echo "$REPO" >> $LISTAREPOS
fi

echo "Updating packages list..."
sleep 3s

apt-get	update >> ZabbixAgent1.8.2.log

if dpkg -l | grep zabbix-agent ;
  then
     echo "I need to delete the zabbix-agent old version. Delete? [y/n]"
       read Respuesta
     case $Respuesta in
       'y' | 'Y') apt-get remove --purge zabbix-agent -y >> ZabbixAgent1.8.2.log
               ;;
       'n' | 'N') echo "Exiting."
                  exit 1
               ;;
               *) echo "Wrong option!..."
                  echo "Exiting."
                  exit 1
               ;;
     esac
fi
       

echo "Installing new zabbix-agente 1.8.2..."
apt-get -t lenny-backports install zabbix-agent -y >> ZabbixAgent1.8.2.log

echo "Replacing data on zabbix_agentd.conf..."
sed -i "s/Server=localhost/Server=$ZabbixServer/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=localhost/Hostname=$HostName/g" /etc/zabbix/zabbix_agentd.conf
sed -i 's/Timeout=3/Timeout=10/g' /etc/zabbix/zabbix_agentd.conf

echo "Restarting zabbix-agent..."
/etc/init.d/zabbix-agent restart >> ZabbixAgent1.8.2.log

exit 0
