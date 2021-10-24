#!/bin/bash
#
#script para backup do banco de dados MYSQL
#
USERBD=USER BANCO
PASSWORD=SENHABANCO
LOG_DIR=/var/log/backup
LOG=$LOG_DIR/backup_db_@ANO$MES$DIA.log

#DATAS
DIA=`date +%d`
MES=`date +%m`
ANO=`date +%Y`
DATA_ATUAL=`date +%Y-%m-%d-%H-%M`

#DATA DE INICIO DO BACKUP
DATA_INICIO=`date +%d/%m/%Y-%H:%M:%S`

#Caminho do arquivo de LOG
LOG_DIR=/var/log/backup
LOG=$LOG_DIR/backup_db_$ANO$MES$DIA.log


#Diretório onde vai ser salvo o backup
DIR_BK=/BACKUP

#Vai varrer para localizar os bancos de dados
DATABASES=(NOMEDOBANCO)


#Verfica se existe o diretória para armazenar os logs
if [ ! -d $LOG_DIR ]; then
	mkdir $LOG_DIR
fi

#Verfica se existe o diretória para armazenar os backups

if [ ! -d $DIR_BK ]; then

	mkdir -p $DIR_BK
	
fi
echo "MYSQL Iniciando em $DATA_INICIO" >> $LOG
#
#Loop para backupear todos os bancos de dados
for db in "${DATABASES[@]}"; do
#MYSQL DUMP
# Para backupear procedures e functions foi adicionado o --routines
mysqldump --routines -u$USERBD -p$PASSWORD $db > $DIR_BK/$db'_'$DATA_ATUAL.sql

echo "Realizando backup do banco ...............[ $db ]" >> $LOG


#Compacta o banco em arquivo BZ2

bzip2 $DIR_BK/$db'_'$DATA_ATUAL.sql


done
DATA_FINAL=`date +%d/%m/%Y-%H:%M:%S`


echo "MYSQLDUMP Finalizando em $DATA_FINAL" >> $LOG

#Remove arquivos de backups antigos  3 dias
find /BACKUP/* ! -ctime -2 -exec rm {} \;
© 2021 GitHub, Inc.
