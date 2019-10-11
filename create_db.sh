#!/bin/bash

# O objetivo deste script é facilitar a criação de bancos de dados no servidor do LAIS
# deste modo, deve ser apenas utilizado pela equipe de infraestrutura e bancos de dados.
#
# Versão 20190225
#

###########################################################################
################################################ Inicializando as variáveis
###########################################################################
FILE="/tmp/out.$$"
GREP="/bin/grep"
PG_HBA="/opt/data/pg_hba.conf"
DATA=$(date +%d-%m-%Y)

###########################################################################
######################################### Função pra validar o IP fornecido
###########################################################################
function validar_ip() 
{

	REGEX_IP='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+$'

	if [[ ! $ip_servidor =~ $REGEX_IP ]]; then
	  echo "Erro ao digitar o IP."
	  exit 1
	fi

}

###########################################################################
######################################################## Checando o usuário
###########################################################################
if [ "$(id -un)" != "postgres" ]; then
   echo "Apenas o usuário POSTGRES pode usar este script!" 1>&2
   exit 1
else

	###########################################################################
	######################################## Prompt de informação das variaveis
	###########################################################################
	echo "" 
	read -p "[1] - Nome do Responsável pelo Sistema : " nome_solicitante

	echo ""
	read -p "[2] - Sistema Solicitante : " nome_sistema

	echo ""
	read -p "[3] - Nome do Usuário : " nome_usuario

	echo ""
	read -p "[4] - Nome do Banco : " nome_banco

	echo ""
	read -p "[5] - Senha do Usuário : " senha_usuario

	echo ""
	read -p  "[6] - Já existe Servidor definido para o Sistema? (s/n)? " servidor
	if echo "$servidor" | grep -iq "^s" ;then
	    read -p "    - Forneça o IP e Máscara do servidor (X.X.X.X/Y) : " ip_servidor

	    ##############################
	    ### Validar o IP fornecido ###
	    ##############################
	    validar_ip $ip_servidor
	else
	    ip_servidor="0.0.0.0/0"
	fi

	###########################################################################
	######################################################### Criando o Usuário
	###########################################################################

	psql -c "create user ${nome_usuario} with password '${senha_usuario}';"

	###########################################################################
	########################################################### Criando o Banco
	###########################################################################

	psql -c "create database ${nome_banco} owner ${nome_usuario};"

	###########################################################################
	################################################# Garantindo os privilégios
	###########################################################################

	psql -c "grant all privileges on database ${nome_banco} to ${nome_usuario};"

	###########################################################################
	################################################ Registrando no pg_hba.conf
	###########################################################################

	echo -e "\n ############# Responsavel : ${nome_solicitante} | Sistema : ${nome_sistema}  ################" >> $PG_HBA
	echo -e "host\t${nome_banco}\t${nome_usuario}\t${ip_servidor}\tmd5" >> $PG_HBA

	###########################################################################
	##################################################### Reiniciando o serviço
	###########################################################################

	set -v
	pg_ctl reload
	set +v

	###########################################################################
	###################################################### Imprimindo Relatório
	###########################################################################

	echo ""
	echo "###########################################################################"
	echo "############################ RELATORIO DE USO #############################"
	echo "###########################################################################"
	echo ""
	echo "Solicitante : ${nome_solicitante}"
	echo "Sistema : ${nome_sistema}"
	echo "Banco : ${nome_banco}"
	echo "Usuario : ${nome_usuario}"
	echo "Senha : ${senha_usuario}"
	echo "IP Liberado : $ip_servidor"
	echo ""
	echo "###########################################################################"
	echo "######################## FIM - ${DATA} ##########################"
	echo "###########################################################################"

fi
