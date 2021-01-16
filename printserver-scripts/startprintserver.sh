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

useradd -g lpadmin -m "${ADMIN}"

echo -e "${ADMINPASS}\n${ADMINPASS}" | passwd "${ADMIN}"
echo -e "${ADMINPASS}\n${ADMINPASS}" | smbpasswd -s -a "${ADMIN}"

#### Start Cups Daemon ######
service cups start

service dbus start
service avahi-daemon start
service cups-browsed start
service ssh start

##### Start Samba Server #####
sleep 1
nmbd
exec smbd -FS -d 2