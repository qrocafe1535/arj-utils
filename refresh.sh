#!/usr/bin/env bash

PASTA=$(dirname "$0") # Informa pasta atual

#CORES
AMARELO='\033[33m'
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
AZUL='\e[1;36m'
SEM_COR='\e[0m'

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
menu_inicio () {
    while :; do
        clear && echo -e "$LOGO_ARJ"
        source $PASTA/config/menus.sh # Carrega menus
        MENU=$(gum choose 'Gerar PTP para Mikrotik' 'Manutenção para Antenas Ubiquit' 'Manutenção Linux' 'Sair')
        if [ "$MENU" == 'Gerar PTP para Mikrotik' ]; then
            menu_mikrotik

        elif [ "$MENU" == 'Manutenção para Antenas Ubiquit' ]; then
            menu_ubquit

        elif [ "$MENU" == 'Manutenção Linux' ]; then
            menu_linux

        elif [ "$MENU" == 'Sair' ]; then
            clear
            break

        else
            continue

        fi
    done
}


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