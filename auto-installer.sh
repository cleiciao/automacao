#/bin/bash
#Desenvolvido por: Cleicião Diego Moro
#e-mail: cmoro@youisp.com.br

# Função para exibir mensagens de erro
error() {
    echo "Erro $1"
    exit 1
}
echo -e  "
#############################################################
#                 __   __                                   #
#                 \ \ / /___   _   _                        #
#                  \ V // _ \ | | | |                       #
#                   | || (_) || |_| |                       #
#     ____          |_| \___/ _\__,_|                       #
#    / ___|   ___  | | _   _ | |_ (_)  ___   _ __   ___     #
#    \___ \  / _ \ | || | | || __|| | / _ \ | '_ \ / __|    #
#     __ ) || (_) || || |_| || |_ | || (_) || | | |\__ \    #
#    |____/  \___/ |_| \__,_| \__||_| \___/ |_| |_||___/    #
#                                                           #
#              Script de instalação de pacotes básicos      #
#                                                           #
#############################################################"
sleep 10
clear
# Verificar se o script está sendo executado com privilégios de root
echo -e "Verificando se o usuário é root..."
sleep 5
clear
if [[ $(id -u) -ne 0 ]]; then
    error "Este script precisa ser executado com privilégios de root!"
fi

echo -e  "Script para instalação de pacotes e serviços básicos"
sleep 5
clear
echo -e "Os pacotes a seguir serão instalados:"
#echo -e "\n"
echo -e "vim neofetch net-tools tcpdump open-vm-tools fail2ban sudo snmp zabbix-agent bash-completion"
sleep 5
clear
#Alterar nome do host
echo -e "Alterar o hostname..."
read -p "Digite o nome do host:" NEW_HOSTNAME
hostnamectl set-hostname $NEW_HOSTNAME || error "Falha na alteração do hostname..."
sleep 3
clear
echo -e "Nome alterado com sucesso..."
sleep 3
clear
#Alterar o nome no arquivo /etc/hosts
echo -e "Alterar o hostname no arquivo /etc/hosts"
sleep 3
nano /etc/hosts
clear
echo -e "Arquivo alterado com sucesso..."
sleep 3
clear
# Atualizar e atualizar o sistema
echo -e "Atualizando sistema..."
sleep 5
clear
apt update
apt upgrade -y || error "Falha ao atualizar o sistema!"
sleep 3
clear

# Instalar pacotes
echo "Instalando pacotes..."
sleep 3
wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-2+debian11_all.deb -P /tmp
dpkg -i /tmp/zabbix-release_5.0-2+debian11_all.deb
apt update
apt install -y  vim neofetch net-tools tcpdump open-vm-tools fail2ban sudo snmp zabbix-agent bash-completion || error "Falha ao instalar os pacotes!"
clear
echo -e "Instalação concluída com sucesso..."
sleep 5
clear
# Alterar a porta SSH para 55022
echo -e "Alterando porta SSH..."
sleep 5
clear
sed -i 's/#Port 22/Port 55022/' /etc/ssh/sshd_config || error "Falha ao alterar a porta SSH!"

# Liberar a porta 55022 no fail2ban
echo -e "Liberando porta SSH no fail2ban..."
sleep 5
clear
sed -i s/=\ ssh/=\ ssh,55022/g /etc/fail2ban/jail.conf

sleep5
clear
#Criar usuário desejado
echo "Criando usuário"
read -p "Digite o nome do usuário: " NEW_USER
read -s -p  "Digite a senha do novo usuário: " NEW_USER_PASSWORD
echo -e "\n"
useradd -m -s /bin/bash -p $(openssl passwd -1 $NEW_USER_PASSWORD) $NEW_USER || error "Falha ao criar o novo usuário!"
echo "Usuário adicionado com  sucesso..."
sleep 5
clear
echo -e "Adicionando usuário  ao grupo de SUDO..."
sleep 5
usermod -G sudo $NEW_USER || error "Falha ao adicionar ao grupo SUDO!"
sleep5
clear
#Alterar auto-completion
echo -e "Alterar /etc/bash.bashrc para configuração de autocomplete"
sleep 5
clear
nano /etc/bash.bashrc
echo -e "Alterações realizadas com sucesso..."
sleep 5
clear
#Alterar IPs autorizados no zabbix agent
echo -e "Alterado IPs do zabbix-agent...."
sleep 5
nano /etc/zabbix/zabbix_agentd.conf
clear
echo "Configuração realizada com sucesso..."
sleep 5
clear
# Reiniciar o Zabbix Agent
echo -e "Reiniciando o Zabbix Agent, SSH e Fail2ban..."
/etc/init.d/zabbix-agent restart || error "Falha ao reiniciar o Zabbix Agent!"
sleep 3
/etc/init.d/ssh restart   || error "Falha ao reiniciar o serviço SSH"
sleep 3
/etc/init.d/fail2ban restart  || error "Falha ao reiniciar o serviço do Fail2ban"
sleep 3
neofetch

echo "Fim do  script..."

#Reiniciar a VM
echo "A maquina será reiniciada em instantes...."
sleep 15

reboot || error "Falha ao reiniciar a VM!"

