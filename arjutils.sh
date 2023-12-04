#!/bin/bash

# Nome = AraujoSat Maintenance Utils (arjutils)
# Autor = Matheus Fellipe (Analista de Rede Jr.)
# Versão = 1.0
#
# Descrição = Esse script foi criado com a finalidade de automatizar diversos dos processos do dia a dia no suporte técnico.
# Sinta-se livre para modificar e utilizar da forma que quiser!

PASTA_ABSOLUTA=$(dirname "$0")

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
# =======================================================================================|
PS3="$RODAPE1"
menu_inicio () {
	while :; do
		clear
		echo -e "$LOGO_ARJ" # Exibe logo no inicio.
		source $PASTA_ABSOLUTA/config/menus.sh # Carrega menus
		select tipo_do_servico in "Gerar PTP para Mikrotik" "Manutenção para Antenas Ubiquit" "Manutenção Linux" "Sair"; do
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
				"Manutenção Linux" )
					clear
					echo -e "$LOGO_ARJ"
					menu_linux
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
		done
	done
}
# =======================================================================================|
# Executa tudo.
if [[ $UID -eq 0 ]]; then # Verifica se for root fecha o programa.
	echo -e "\n${VERMELHO}[ERRO]${SEM_COR} O programa não deve ser executado como root."
	sleep 2
	exit 1
fi

if [[ "$1" = "--exploit" && $(lsb_release -si) == "Ubuntu" ]]; then # executa exploit
		main_exec_exploit
		exit 1
	elif [[ "$1" = "--exploit" && $(lsb_release -si) == "Debian" ]]; then # executa exploit
		main_exec_exploit
		exit 1
	else # executa o menu
		menu_inicio
fi
# =======================================================================================|