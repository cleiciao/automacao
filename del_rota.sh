#!/bin/bash
#Autor: Cleicião Diego Moro
#e-mail: cleiciaodiego@gmail.com
#o script altera  a rota do servidor quando ele é inicializado.
#Aqui criei ele como um serviço para que possa habilitar/desabilitar iniciar restartar e dar stop no mesmo.
#
#o comando abaixo vai adicionar uma nova rota, bastando somente alterar os IPs para seu cenario, ele ficara dentro de um script
#no diretório /opt/ para utilizar basta alterar os IPs para o seu cenário.

route del default ip route add x.x.x.x/x via xxx.xxx.xxx.xxx src xxx.xxx.xxx.xxx


#a configuração automatica do script foi criada como serviço.
#dentro de /etc/systemd/system/del_route.service
#as linhas abaixo configuram o serviço 
[Unit]
Description="Deleta_Rota"
After=network.target

[Service]
Type=simple
#essa linha executa o script que foi criado antiormente salvei o script em /opt/del_rota.sh isso pode mudar dependendo de onde você salvou.
ExecStart=/bin/bash /opt/del_rota.sh
TimeoutStartSec=0


[Install]
WantedBy=default.target

#Obs: caso você precise parar a execução do script na inicialização do SO, basta desabilitar o serviço systemctl disable nomedoservico que no meu caso ficou del_route.service
 
