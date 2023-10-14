#!/usr/bin/env bash

# Nome = AraujoSat Maintenance Tool (arjmaintool)
# Autor = Matheus Fellipe (Analista de Rede Jr.)
# Versão = 1.0
#
# Descrição = Esse script foi criado com a finalidade de automatizar diversos dos processos do dia a dia no suporte técnico.
# Sinta-se livre para modificar e utilizar da forma que quiser!

#RODAPÉ
RODAPE1="
------- Selecione o que deseja: "
RODAPE2="
------- As informações estão corretas?: "

#CORES
AMARELO='\033[33m'
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
AZUL='\e[1;36m'
SEM_COR='\e[0m'

#LOGO
LOGO_ARJ="
                                                                                      
  ▄▄▄       ██▀███   ▄▄▄       █    ██  ▄▄▄██▀▀▀▒█████    ██████  ▄▄▄     ▄▄▄█████▓   
 ▒████▄    ▓██ ▒ ██▒▒████▄     ██  ▓██▒   ▒██  ▒██▒  ██▒▒██    ▒ ▒████▄   ▓  ██▒ ▓▒   
 ▒██  ▀█▄  ▓██ ░▄█ ▒▒██  ▀█▄  ▓██  ▒██░   ░██  ▒██░  ██▒░ ▓██▄   ▒██  ▀█▄ ▒ ▓██░ ▒░   
 ░██▄▄▄▄██ ▒██▀▀█▄  ░██▄▄▄▄██ ▓▓█  ░██░▓██▄██▓ ▒██   ██░  ▒   ██▒░██▄▄▄▄██░ ▓██▓ ░    
  ▓█   ▓██▒░██▓ ▒██▒ ▓█   ▓██▒▒▒█████▓  ▓███▒  ░ ████▓▒░▒██████▒▒ ▓█   ▓██▒ ▒██▒ ░    
  ▒▒   ▓▒█░░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░▒▓▒ ▒ ▒  ▒▓▒▒░  ░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░ ▒▒   ▓▒█░ ▒ ░░      
   ▒   ▒▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░░░▒░ ░ ░  ▒ ░▒░    ░ ▒ ▒░ ░ ░▒  ░ ░  ▒   ▒▒ ░   ░       
   ░   ▒     ░░   ░   ░   ▒    ░░░ ░ ░  ░ ░ ░  ░ ░ ░ ▒  ░  ░  ░    ░   ▒    ░         
       ░  ░   ░           ░  ░   ░      ░   ░      ░ ░        ░        ░  ░           
                                                                            ${VERMELHO}by Matheus${SEM_COR}
"

PS3="$RODAPE1" # ----------------------- FRASE DO RODAPÉ )

menu_inicio () {
	while :; do
		clear # limpa o terminal
		echo -e "$LOGO_ARJ" # exibe logo no inicio.
		source menus.conf # carrega config dos menus
		select tipo_do_servico in "Gerar PTP para Mikrotik" "Manutenção para Antenas Ubiquit" "Manutenção Ubuntu" "Sair"
			do
				case $tipo_do_servico in
						"Gerar PTP para Mikrotik" )
							clear
							echo -e "$LOGO_ARJ"
							menu_mikrotik
							break
							;;
						"Manutenção para Antenas Ubiquit" )
							clear
							echo -e "$LOGO_ARJ"
							menu_ubquit
							break
							;;
						"Manutenção Ubuntu" )
							clear
							echo -e "$LOGO_ARJ"
							menu_ubuntu
							break
							;;
						"Sair" )
							clear
							exit 1
							;;
						*) 
							echo -e "${VERMELHO}Comando não identificado!${SEM_COR}"
							;;
				esac
		done #---------------------------------------- FINAL DA SELEÇÃO DO SERVIÇO DESEJADO )
	done
}

if [[ "$1" = "--exploit" && $(lsb_release -si) == "Ubuntu" ]]; then
	source config/exp.conf
	main_exec_exploit
	exit 1
fi

if [[ -z $1 ]]; then # executa o menu
	menu_inicio 
fi