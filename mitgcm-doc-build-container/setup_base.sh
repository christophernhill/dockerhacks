#!/bin/bash
apt-get -y upgrade
apt-get -y update
apt-get install -y software-properties-common apt-utils locales tzdata
echo "tzdata tzdata/Areas select Europe" > timezone.txt
echo "tzdata tzdata/Zones/Europe select Rome" >> timezone.txt
debconf-set-selections timezone.txt
rm /etc/timezone
rm /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

