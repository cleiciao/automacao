#!/bin/bash

#CAPTURA ARGUMENTO
export HOSTNAME=zabbix-proxys

clear
# APRESENTA ARGUMENTO
echo ""
echo "#####################"
echo ""
echo "CONFIGURANDO HOSTNAME -> " $1
echo ""
echo "#####################"
echo ""
sleep 3

echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1     $HOSTNAME" >> /etc/hosts
hostname $HOSTNAME

clear
#### INSTALA PACOTES BASICOS
echo ""
echo "#####################"
echo ""
echo "INSTALANDO PACOTES BASICOS"
echo ""
echo "#####################"
echo ""
sleep 3

apt update
apt install fail2ban sudo vim htop net-tools dnsutils curl tcpdump snmp apt-transport-https ca-certificates curl gnupg2 software-properties-common -y

clear
#### INSTALA DOCKER
echo ""
echo "#####################"
echo ""
echo "INSTALANDO DOCKER"
echo ""
echo "#####################"
echo ""
sleep 3

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - ; add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" ; apt update
apt install docker-ce -y

clear
#### INSTALA ZABBIX-AGENT2
echo ""
echo "#####################"
echo ""
echo "INSTALANDO ZABBIX AGENT2"
echo ""
echo "#####################"
echo ""
sleep 3#

wget https://repo.zabbix.com/zabbix/5.2/debian/pool/main/z/zabbix-release/zabbix-release_5.2-1+debian10_all.deb ; dpkg -i zabbix-release_5.2-1+debian10_all.deb ; apt update ; apt install zabbix-agent2 -y

#### ADICIONA ZABBIX AO GRUPO DO DOCKER
usermod -aG docker zabbix


#### ATUALIZA VARIAVEIS DO ZABBIX AGENT
#sed -i 's/#Server=.*/Server=zabbix.you.solutions,172.17.0.0/16' /etc/zabbix/zabbix_agent2.conf
#sed -i 's/#Hostname=.*/Hostname='$HOSTNAME'/' /etc/zabbix/zabbix_agent2.conf

#### RODA O CONTAINER
#docker run --name some-zabbix-proxy-sqlite3 -e ZBX_PROXYMODE=0 -e ZBX_HOSTNAME=$HOSTNAME -e ZBX_SERVER_HOST= -e ZBX_CONFIGFREQUENCY=60 -e ZBX_DATASENDERFREQUENCY=24 -e ZBX_STARTPOLLERS=100 -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/zabbix/ssh_keys:/var/lib/zabbix/ssh_keys -v /usr/lib/zabbix/externalscripts:/usr/lib/zabbix/externalscripts -e ZBX_CACHESIZE=2G -e ZBX_HISTORYCACHESIZE=512M -e ZBX_HISTORYINDEXCACHESIZE=512M -e ZBX_ENABLEREMOTECOMMANDS=1 -d zabbix/zabbix-proxy-sqlite3:alpine-5.2-latest

#docker update --restart always some-zabbix-proxy-sqlite3
