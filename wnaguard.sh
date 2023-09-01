#!/bin/bash
# Função para exibir caixa de diálogo Sim/Não
ask_yes_no() {
    dialog --backtitle "$1" --yesno "$2" 13 60
    return $?
}




# Função para exibir menu de seleção de sistema operacional
select_os() {
    dialog --backtitle "Seleção de Sistema Operacional" --menu "Qual distribuição você esta utilizando?:" 15 40 5 \
        1 "Debian" \
        2 "Ubuntu" \
        3 "CentOS" \
        4 "Red Hat" \
        5 "Sair" 2> /tmp/os_choice
    choice=$(cat /tmp/os_choice)
    rm /tmp/os_choice
    return $choice
}

# Exibir mensagem de aviso e perguntar 
ask_yes_no  "Aviso!" "Esse script foi desenvolvido para auxiliar na instalação dos pacotes necessários para implementação da ferramenta Anti-DDoS da empresa Andrisoft o  WANGUARD.  \n\n\nScript criado por: Cleicião Diego Moro \n\n\nDeseja continuar?" || exit 0



# Ir diretamente para o menu de seleção de sistema operacional
select_os

# Restante do seu script...
#Instalação dos pacotes necessários
case $choice in
     1) os="Debian"
	clear
	 dialog --backtitle "Continuando..." --timeout 3 --infobox "Você escolheu $os. \n\n Os pacotes serão instalados..." 10 40 
        #echo "Você escolheu $os."
	sleep 5
	clear
	dialog --backtitle "Instalando..." --timeout 3 --infobox "Instalando Pacotes: \n\napt-transport-https wget gnupg" 10 40
	sleep 3
	clear
	dialog --backtitle "Continuando" --timeout 3 --infobox "Adicionando repositorio Andrisoft nas listas do apt... \n\n\n\nhttps://www.andrisoft.com/files/debian11 bullseye main" 10 40
        apt update &>/dev/null
        apt install -y apt-transport-https wget gnupg &>/dev/null || error "Falha ao instalar pacotes."
        wget -q -O - https://www.andrisoft.com/andrisoft.gpg.key | gpg --dearmor --yes --output /usr/share/keyrings/andrisoft-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/andrisoft-keyring.gpg] https://www.andrisoft.com/files/debian11 bullseye main" > /etc/apt/sources.list.d/andrisoft.list 
	apt update  &>/dev/null
	clear
	dialog --backtitle "Continuando" --timeout 3 --infobox "Instalando WANCONSOLE... \n\n\n\apt install -y wanconsole" 10 40
	sleep 3
	#export DEBIAN_FRONTEND=noninteractive
	apt install -y wanconsole > /dev/null 2>&1 || error
	sleep 3
	clear
	dialog --backtitle "Continuando..." --timeout 3 --infobox "Alterando servidores NTP para: \n\n\nFallbackNTP=\na.ntp.br \nb.ntp.br \nc.ntp.br" 10 40 
	sleep 3
	sed -i 's/^#FallbackNTP=.*/FallbackNTP=a.ntp.br b.ntp.br/' /etc/systemd/timesyncd.conf
	timedatectl set-ntp true
	sleep 3
	clear
	dialog --backtitle "Continuando" --timeout 3 --infobox "Alterando configuração do Mysql, comentando a linha bind_address...\n\n\n#bind-address  = 127.0.0.1" 10 40
	sleep 3
	sed -i 's/^bind-address/#bind-address/' /etc/mysql/mariadb.conf.d/50-server.cnf
	systemctl restart mariadb
	sleep 3
	clear
	dialog --backtitle "Continuando" --timeout 3 --infobox "Ajustando Timezone para: \n\n\nTimezone= America/Sao_Paulo" 10 40
	sleep 3
	clear
        sed -i 's/^;date.timezone =/date.timezone = America\/Sao_Paulo/' /etc/php/7.4/apache2/php.ini
	sed -i 's/^;date.timezone =/date.timezone = America\/Sao_Paulo/' /etc/php/7.4/cli/php.ini
	systemctl restart apache2
	clear
	dialog --backtitle "Continuando" --timeout 3 --infobox "Instalação do Console Wanguard.... \n\n\nnopt/andrisoft/bin/install_console" 10 40
	sleep 3
	clear
	/opt/andrisoft/bin/install_console
	clear
	dialog --backtitle "Continuando" --timeout 3 --infobox "Configuração do Supervisor.\n\n\n\n/opt/andrisoft/bin/install_supervisor" 10 40
	sleep 3
	/opt/andrisoft/bin/install_supervisor
	systemctl start WANsupervisor
	systemctl enable WANsupervisor
	dialog --backtitle "Continuando" --timeout 3 --infobox "Instalando e configurando e configurando o Influxdb." 10 40
	sleep 3
	wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.10_amd64.deb &>/dev/null 
 	dpkg -i ./influxdb_1.8.10_amd64.deb &>/dev/null
	cp /etc/influxdb/influxdb.conf /etc/influxdb/influxdb.conf.backup
	cp /opt/andrisoft/etc/influxdb.conf /etc/influxdb/influxdb.conf
	systemctl restart influxdb
	/opt/andrisoft/bin/install_influxdb
	clear  
	dialog --backtitle "Instalação Concluída" --msgbox "A instalação foi concluída com sucesso!\n\nVocê pode acessar a ferramenta WANGUARD através do seguinte endereço IP:\n\nhttp://ip-do-servidor/wanguard \n\nObrigado por usar o script!" 15 60
	sleep 5 
	clear
	;;
    2) os="Ubuntu" ;;
    3) os="CentOS" ;;
    4) os="Red Hat" ;;
    5) echo "Saindo..."
       exit 0 ;;
    *) echo "Escolha inválida."
       exit 1 ;;
esac
