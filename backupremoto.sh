#!/bin/bash
#Para que o script funcionasse de maneira correta foi gerado chaves RSA para login automatico no host remoto
LOG=/var/log/backupremoto.log
rsync -av --rsh="ssh -l bkpftp" /BACKUP/ bkpftp@ipremoto:/diretorio
