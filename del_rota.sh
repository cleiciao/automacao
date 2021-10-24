#!/bin/bash
#o comando abaixo vai adicionar uma nova rota
route del default ip route add x.x.x.x/x via xxx.xxx.xxx.xxx src xxx.xxx.xxx.xxx


#a configuração automatica do script foi criada como serviço.
#dentro de /etc/systemd/system/del_route.service
#as linhas abaixo configuram o serviço 
[Unit]
Description="Deleta_Rota"
After=network.target

[Service]
Type=simple
#essa linha executa o script que foi criado antiormente
ExecStart=/bin/bash /opt/del_rota.sh
TimeoutStartSec=0


[Install]
WantedBy=default.target
