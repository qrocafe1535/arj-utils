menu_mikrotik () {
    source $PASTA/config/mikrotik.sh
    tipo_do_ptp=$(gum choose 'Gerar PTP para PPPoE' 'Gerar PTP para Bridge' 'Comando para setar o L2MTU Máximo' 'Voltar')

   	if [[ "$tipo_do_ptp" = "Gerar PTP para PPPoE" ]]; then 	# ------------------------------------------- INICIO PONTO A PONTO DE PPPOE ) 
        ptp_tipo_pppoe

    elif [[ "$tipo_do_ptp" = "Gerar PTP para Bridge" ]]; then  #--------------------------------------------------------- PONTO A PONTO BRIDGE - INICIO) 
        ptp_tipo_bridge

    elif [[ "$tipo_do_ptp" = "Comando para setar o L2MTU Máximo" ]]; then
        echo -e "\n/int ethernet set l2mtu=20000 [f]\n"
        sleep 3

   fi

}

menu_ubquit () {
        source $PASTA/config/ubquit.sh
    tipo_do_ptp=$(gum choose "Gerar BKP para Antena Ubiquit" "Download Atualização das Antenas v.6.3.11" "Gerar lista de Canais" "Voltar")
        if [[ "$tipo_do_ptp" == "Gerar BKP para Antena Ubiquit" ]]; then
            gerar_config_painel

        elif [[ "$tipo_do_ptp" == "Download Atualização das Antenas v.6.3.11" ]]; then
            download_att_antenas

        elif [[ "$tipo_do_ptp" == "Gerar lista de Canais" ]]; then
            lista_de_canais
            gum confirm --affirmative="Sim" --negative="Não" "Deseja exportar um arquivo contendo a lista?" && lista_de_canais > Lista_de_canais.txt

    fi
}


menu_linux () {
    man_ubuntu=$(gum choose "Instalação de Programas para o Suporte" "Instalar Winbox + TheDude" "Habilitar update automático as 09:00" "Voltar")
        if [[ "$man_ubuntu" == "Instalação de Programas para o Suporte" && $(lsb_release -si) == "Ubuntu" ]]; then
            source $PASTA/config/ubuntu.sh
            main_update_ubuntu

        elif [[ "$man_ubuntu" == "Instalação de Programas para o Suporte" && $(lsb_release -si) == "Debian" ]]; then
            source $PASTA/config/debian.sh
            main_update_debian

        elif [[ "$man_ubuntu" == "Instalação de Programas para o Suporte" ]]; then
            echo -e "\n${VERMELHO}Ops... \nO sistema utlizado não parece ser compativel com o script.\n${SEM_COR}"
            sleep 3

        elif [[ "$man_ubuntu" == "Instalar Winbox + TheDude" ]]; then
            mk_soft
            system_clean

        elif [[ "$man_ubuntu" == "Habilitar update automático as 09:00" ]]; then
            cron_update_auto

    fi 

}