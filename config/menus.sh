menu_mikrotik () {
	source config/mikrotik.sh # carrega lib mikrotiks
			select tipo_do_ptp in "Gerar PTP para PPPoE" "Gerar PTP para Bridge" "Setar L2MTU Máximo" "Voltar" "Sair"
			do
				case $tipo_do_ptp in
				"Gerar PTP para PPPoE" )
						break
						;;
				"Gerar PTP para Bridge" )
					break
						;;
				"Setar L2MTU Máximo" )
					echo -e "\n/int ethernet set l2mtu=20000 [f]\n"
					seta_max_l2mtu
					break
						;;
					"Voltar" )
					break
						;;
					"Sair" )
						clear
						exit 1
						;;
					* ) 
						echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
						;;
					
				esac
			done

	if [[ "$tipo_do_ptp" = "Gerar PTP para PPPoE" ]]; then 	# ------------------------------------------- INICIO PONTO A PONTO DE PPPOE ) 
			ptp_tipo_pppoe
	fi 

	if [[ "$tipo_do_ptp" = "Gerar PTP para Bridge" ]]; then  #--------------------------------------------------------- PONTO A PONTO BRIDGE - INICIO) 
			ptp_tipo_bridge
	fi
}


menu_ubquit () {
	source config/ubquit.sh # config da sessão ubquit
	PS3="$RODAPE1" # ----------------------- FRASE DO RODAPÉ )

	select MANUBQUIT in "Gerar BKP para Antena Ubiquit" "Download Atualização das Antenas v.6.3.11" "Gerar lista de Canais" "Voltar" "Sair"
	do
		case $MANUBQUIT in
			"Gerar BKP para Antena Ubiquit" )
        gerar_config_painel
					break
						;;
			"Download Atualização das Antenas v.6.3.11" )
        download_att_antenas
					break
						;;
			"Gerar lista de Canais" )
              lista_de_canais
              
              echo "Deseja que seja criado um arquivo contendo a lista?"
              select STATUSLISTA in "Sim!" "Não."
                do
                case $STATUSLISTA in
                    "Sim!" )
                      lista_de_canais > Lista_de_canais.txt
                      echo -e "${VERDE}\nLista de canais exportada com sucesso!${SEM_COR}"
                      break
                      ;;
                    "Não." )
                      echo "Saindo!..."
                      break
                      ;;
                    *) 
                      echo -e "${VERMELHO}Comando não identificado!${SEM_COR}"
                      ;;
                esac
              done
					break
						;;	
			"Voltar" )
				break
				;;
			"Sair" )
				clear
				exit 1
				;;
			* ) 
				echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
						;;
			
		esac
	done
}

menu_linux () {
	if [[ $(lsb_release -si) == "Ubuntu" ]]; then
		PS3="$RODAPE1" # -------------------------- FRASE DO RODAPÉ )		
		source config/ubuntu.sh
		echo -e "\nSistema detectado = ${VERDE}UBUNTU${SEM_COR}\n"
		sleep 1
			select man_ubuntu in "Instalação de Programas para o Suporte" "Instalar Winbox + TheDude" "Habilitar update automático as 09:00" "Voltar" "Sair"; do
				case $man_ubuntu in 
					"Instalação de Programas para o Suporte" )
						main_update_ubuntu # executa uma manutenção completa bem como a Instalação do Winbox + The dude
						break
							;;
					"Instalar Winbox + TheDude" )
						mk_soft # instala winbox e the dude client.
						system_clean # limpa o sistema.
						break
							;;
					"Habilitar update automático as 09:00" )
						cron_update_auto # Habilita o update automático via cron.
						break
							;;
					"Voltar" )
						break
							;;
					"Sair" )
						clear
						exit 1
							;;
					* ) 
						echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
							;;
				esac
			done
# --------------------------------------------------------------------------------------------------------------#
	elif [[ $(lsb_release -si) == "Debian" ]]; then # sessão do debian
		PS3="$RODAPE1" # -------------------------- FRASE DO RODAPÉ )
		source config/debian.sh
		echo -e "\nSistema detectado = ${VERDE}DEBIAN${SEM_COR}\n"
		sleep 1
				select man_debian in "Instalação de Programas para o Suporte" "Instalar Winbox + TheDude" "Habilitar update automático as 09:00" "Voltar" "Sair"; do
				case $man_debian in 
					"Instalação de Programas para o Suporte" )
						main_update_debian # executa uma manutenção completa bem como a Instalação do Winbox + The dude
						break
							;;
					"Instalar Winbox + TheDude" )
						mk_soft # instala winbox e the dude client.
						system_clean # limpa o sistema.
						break
							;;
					"Habilitar update automático as 09:00" )
						cron_update_auto # Habilita o update automático via cron.
						break
							;;
					"Voltar" )
						break
							;;
					"Sair" )
						clear
						exit 1
							;;
					* ) 
						echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
							;;
				esac
			done
		else 
			echo -e "\n${VERMELHO}Ops... \nO sistema utlizado não parece ser compativel com o script.\n${SEM_COR}"
				sleep 3
		fi
}
