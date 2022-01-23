#!/bin/bash
#Autor: cleiciao diego moro
#e-mail: cleiciaodiego@gmail.com
#Atualização do SO
##
#
#
echo "Atualização do SO, aguarde..."
apt update && apt upgrade -y
#
#
#
#
echo "O mysql-server necessita de algumas dependencias, aguarde..."

apt install -y gnupg lsb-release

echo "Baixando e instalando o repositório, aguarde..."

wget https://dev.mysql.com/get/mysql-apt-config_0.8.19-1_all.deb
dpkg -i mysql-apt-config_0.8.19-1_all.deb
apt update


echo "Agora iremos instalar o Mysql"

apt install -y mysql-server 

echo "Verificando se o serviço foi instalado."
mysql --version 

#mysql  Ver 15.1 Distrib 10.3.31-MariaDB, for debian-linux-gnu (x86_64) using readline 5.2
