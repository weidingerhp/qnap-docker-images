#!/bin/bash
##### Prepare Users for Cups #####
if [ "${ADMIN}" == "" ]
then
    ADMIN=admin
fi

if [ "${ADMINPASS}" == "" ]
then
    ADMINPASS=password
fi 

useradd -g lpadmin -G sudo -m "${ADMIN}"

echo -e "${ADMINPASS}\n${ADMINPASS}" | passwd "${ADMIN}"
echo -e "${ADMINPASS}\n${ADMINPASS}" | smbpasswd -s -a "${ADMIN}"

#### Start Cups Daemon ######
service cups start
service cups-browsed start
service dbus start

##### Update the avahi daemon files #####
rm /etc/avahi/services/AirPrint-*
python3 /opt/airprint-generate.py -d /etc/avahi/services/ -v

##### Start all the rest of the services
service avahi-daemon start
service ssh start

##### Start Samba Server #####
sleep 1
nmbd
exec smbd -FS -d 2
