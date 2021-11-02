#/bin/bash
#crido por: Cleicião Diego Moro
#e-mail: cleiciaodiego@gmail.com

#caputra argumento
export HOSTNAME=zabbix

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
apt install fail2ban sudo vim htop net-tools dnsutils tcpdump snmp apt-transport-https ca-certificates curl gnupg2 software-properties-common -yclear


#### Criando network dedicada para o zabbix
echo ""
echo "#####################"
echo ""
echo "Criando network dedicada para o zabbix"
echo ""
echo "#####################"
echo ""
sleep 3

docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net


#### Criando instancias do  zabbix
echo ""
echo "#####################"
echo ""
echo "Criando instancias do  zabbix"
echo ""
echo "#####################"
echo ""
sleep 3

#### Criando instancia mysql-server
echo ""
echo "#####################"
echo ""
echo "Criando instancia mysql-server"
echo ""
echo "#####################"
echo ""
sleep 3

docker run --name mysql-server -t \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      --network=zabbix-net \
      -d mysql:8.0 \
      --restart unless-stopped \
      --character-set-server=utf8 --collation-server=utf8_bin \
      --default-authentication-plugin=mysql_native_password
	  
	  
#### Criando instancia zabbix-server
echo ""
echo "#####################"
echo ""
echo "Criando instancia zabbix-server"
echo ""
echo "#####################"
echo ""
sleep 3	  

docker run --name zabbix-server-mysql -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
      --network=zabbix-net \
      -p 10051:10051 \
      --restart unless-stopped \
      -d zabbix/zabbix-server-mysql:alpine-5.4-latest	  
	  
 
#### Criando instancia front-end
echo ""
echo "#####################"
echo ""
echo "Criando instancia front-end"
echo ""
echo "#####################"
echo ""
sleep 3	 

docker run --name zabbix-web-nginx-mysql -t \
      -e ZBX_SERVER_HOST="zabbix-server-mysql" \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      --network=zabbix-net \
      -p 80:8080 \
      --restart unless-stopped \
      -d zabbix/zabbix-web-nginx-mysql:alpine-5.4-latest	  
