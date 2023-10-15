ptp_pppoe_bh1 () {
echo \
"
/
/interface bridge add name=bridge1
/interface wireless set [ find default-name=wlan1 ] band=5ghz-a/n channel-width=20/40mhz-XX country=no_country_set disabled=no frequency=5500 frequency-mode=superchannel mode=bridge nv2-preshared-key=bh1#$ID nv2-security=enabled ssid=BH1-ARAUJOSAT-$ID wireless-protocol=nv2 wps-mode=disabled
/interface wireless set [ find default-name=wlan1 ] disabled=no
/interface bridge port add bridge=bridge1 interface=wlan1
/interface bridge port add bridge=bridge1 interface=[/interface ethernet find default-name=ether1]
/ip address add address=$BH1 interface=bridge1
/ip route add distance=254 gateway=$GATEWAY
/ip service set winbox port=47569
/system identity set name=BH1-ARAUJOSAT-$ID
/snmp community set [ find default=yes ] addresses=10.51.200.4/32,10.51.200.9/32 name=arj_sat
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/user group add name=netconfig policy=local,ssh,ftp,read,policy,test,!telnet,!reboot,!write,!winbox,!password,!web,!sniff,!sensitive,!api,!romon,!dude,!tikapp
/ip service set telnet disabled=yes port=47589
/ip service set ftp address=186.249.81.30/32 port=47589
/ip service set www disabled=yes
/ip service set ssh disabled=no address=45.178.225.110/32,186.249.81.30/32,100.127.255.0/24 port=50004
/ip service set api disabled=yes
/ip service set winbox address=186.249.81.30/32,100.127.255.0/24 port=47569
/ip service set api-ssl disabled=yes
/ppp aaa set use-radius=yes
/radius add address=10.51.200.2 comment=HEXANETWORKS secret=\"}grZ6@Y#(fv1dV)@(gQz\" service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/user add group=full address=186.249.81.30 name=$user_ptp password=$user_password
/user remove admin
/$add_l2mtu
/
" > "BH1-ARAUJOSAT-${LOGIN}-${ID}.rsc"
}

ptp_pppoe_bh2 () {
echo \
"
/
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 disabled=no interface=wlan1 name=pppoe-out-AraujoSat password=$SENHA use-peer-dns=yes user=$LOGIN
/interface wireless set [ find default-name=wlan1 ] band=5ghz-a/n channel-width=20/40mhz-XX disabled=no frequency=5500 frequency-mode=superchannel country=no_country_set mode=station-bridge nv2-preshared-key=bh1#$ID nv2-security=enabled scan-list=default,5100-6000 ssid=BH1-ARAUJOSAT-$ID wireless-protocol=nv2
/interface wireless set [ find default-name=wlan1 ] disabled=no
/ip address add address=192.168.1.1/24 interface=[/interface ethernet find name=ether1] network=192.168.1.0
/ip firewall nat add action=masquerade chain=srcnat out-interface=pppoe-out-AraujoSat src-address=192.168.1.0/24
/ip firewall nat add action=dst-nat chain=dstnat dst-port=8080 in-interface=pppoe-out-AraujoSat protocol=tcp to-addresses=192.168.1.10 to-ports=8080
/system identity set name=BH2-ARAUJOSAT-$ID
/ip pool add name=dhcp_pool_arj ranges=192.168.1.2-192.168.1.254
/ip dhcp-server add address-pool=dhcp_pool_arj disabled=no interface=[/interface ethernet find name=ether1] name=dhcp1
/ip dhcp-server network add address=192.168.1.0/24 dns-server=186.249.81.2,186.249.81.4 gateway=192.168.1.1
/snmp community set [ find default=yes ] addresses=10.51.200.4/32,10.51.200.9/32 name=arj_sat
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/user group add name=netconfig policy=local,ssh,ftp,read,policy,test,!telnet,!reboot,!write,!winbox,!password,!web,!sniff,!sensitive,!api,!romon,!dude,!tikapp
/ip service set telnet disabled=yes port=47589
/ip service set ftp address=186.249.81.30/32 port=47589
/ip service set www disabled=yes
/ip service set ssh disabled=no address=45.178.225.110/32,186.249.81.30/32,100.127.255.0/24 port=50004
/ip service set api disabled=yes
/ip service set winbox address=186.249.81.30/32,100.127.255.0/24 port=47569
/ip service set api-ssl disabled=yes
/ppp aaa set use-radius=yes
/radius add address=10.51.200.2 comment=HEXANETWORKS secret=\"}grZ6@Y#(fv1dV)@(gQz\" service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/user add group=full address=186.249.81.30 name=$user_ptp password=$user_password
/user remove admin
/$add_l2mtu
/
" > "BH2-ARAUJOSAT-${LOGIN}-${ID}.rsc"
}

ptp_bridge_bh1 () {
echo \
"
/
/interface bridge add name=bridge1
/interface wireless set [ find default-name=wlan1 ] band=5ghz-a/n channel-width=20/40mhz-XX country=no_country_set disabled=no frequency=5500 frequency-mode=superchannel mode=bridge nv2-preshared-key=bh1#$LOCAL nv2-security=enabled ssid=BH1-$LOCAL wireless-protocol=nv2 wps-mode=disabled
/interface bridge port add bridge=bridge1 interface=[/interface ethernet find name=ether1]
/interface bridge port add bridge=bridge1 interface=wlan1
/ip address add address=$BH1 interface=bridge1
/ip route add distance=254 gateway=$GATEWAY
/system identity set name=BH1-$LOCAL-ARAUJOSAT
/snmp community set [ find default=yes ] addresses=10.51.200.4/32,10.51.200.9/32 name=arj_sat
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/user group add name=netconfig policy=local,ssh,ftp,read,policy,test,!telnet,!reboot,!write,!winbox,!password,!web,!sniff,!sensitive,!api,!romon,!dude,!tikapp
/ip service set telnet disabled=yes port=47589
/ip service set ftp address=186.249.81.30/32 port=47589
/ip service set www disabled=yes
/ip service set ssh disabled=no address=45.178.225.110/32,186.249.81.30/32,100.127.255.0/24 port=50004
/ip service set api disabled=yes
/ip service set winbox address=186.249.81.30/32,100.127.255.0/24 port=47569
/ip service set api-ssl disabled=yes
/ppp aaa set use-radius=yes
/radius add address=10.51.200.2 comment=HEXANETWORKS secret=\"}grZ6@Y#(fv1dV)@(gQz\" service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/user add group=full address=186.249.81.30 name=$user_ptp password=$user_password
/user remove admin
/$add_l2mtu
/
" > "BH1-${LOCAL}-ARAUJOSAT.rsc"
}

ptp_bridge_bh2 () {
				echo \
"
/
/interface bridge add name=bridge1
/interface wireless set [ find default-name=wlan1 ] band=5ghz-a/n channel-width=20/40mhz-XX country=no_country_set disabled=no frequency-mode=superchannel mode=station-bridge nv2-preshared-key=bh1#$LOCAL nv2-security=enabled radio-name=BH2-$LOCAL scan-list=default,5100-6000 ssid=BH1-$LOCAL wireless-protocol=nv2
/interface wireless nstreme set wlan1 enable-nstreme=yes
/interface wireless security-profiles set [ find default=yes ] supplicant-identity=MikroTik
/interface bridge port add bridge=bridge1 interface=[/interface ethernet find name=ether1]
/interface bridge port add bridge=bridge1 interface=wlan1
/ip address add address=$BH2 interface=bridge1
/ip route add distance=254 gateway=$GATEWAY
/system identity set name=BH2-$LOCAL-ARAUJOSAT
/snmp community set [ find default=yes ] addresses=10.51.200.4/32,10.51.200.9/32 name=arj_sat
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/user group add name=netconfig policy=local,ssh,ftp,read,policy,test,!telnet,!reboot,!write,!winbox,!password,!web,!sniff,!sensitive,!api,!romon,!dude,!tikapp
/ip service set telnet disabled=yes port=47589
/ip service set ftp address=186.249.81.30/32 port=47589
/ip service set www disabled=yes
/ip service set ssh disabled=no address=45.178.225.110/32,186.249.81.30/32,100.127.255.0/24 port=50004
/ip service set api disabled=yes
/ip service set winbox address=186.249.81.30/32,100.127.255.0/24 port=47569
/ip service set api-ssl disabled=yes
/ppp aaa set use-radius=yes
/radius add address=10.51.200.2 comment=HEXANETWORKS secret=\"}grZ6@Y#(fv1dV)@(gQz\" service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/user add group=full address=186.249.81.30 name=$user_ptp password=$user_password
/user remove admin
/$add_l2mtu
/
" > "BH2-${LOCAL}-ARAUJOSAT.rsc"
}

adicionar_usuario_mk () {
		select adicionar_usuario in "Padrão." "Custom." #  ----------------------------------- ( DESEJA ADICIONAR USUÁRIO DEFAULT?)
		do
				case $adicionar_usuario in
				Padrão. )
					user_ptp="sup@sat"
					user_password='"lRz\$&1hd=vW+yD1kw32sH7qC+e\$ONnHN.6qs+Ri}"'
					break
						;;
				Custom. )
				read -p "Digite o Usuário: " user_ptp
				read -s -p "Digite a Senha: " user_password
					break
						;;
				* )
					echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
						;;
			esac
		done #  ----------------------------------- ( FINAL DESEJA ADICIONAR USUÁRIO DEFAULT?)
} 

seta_max_l2mtu () {
		select set_l2mtu in "Sim!" "Não."
		do
			case $set_l2mtu in 
			Sim! )
				add_l2mtu='int ethernet set l2mtu=20000 [f]'
				break
					;;
			Não. )
				add_l2mtu=''
				break
					;;
			esac
		done
}

identifica_bloco () { # identifica o bloco que será utilizado
	echo -e "\nQual o bloco que será utilizado? \nUtilize o formato: ${AZUL}X.X.X.X Y${SEM_COR}"
	read -p "Endereço IP: " ip mask

# variaveis 
	network=$( echo "$ip" | cut -d "." -f1,2,3 ) # network ip
	host=$( echo "$ip" | cut -d "." -f4 ) # separa o ultimo octeto do host da rede
	host_mask=$( echo "$mask" | cut -d "." -f4 ) # separa o ultimo octeto da mascara da rede

	if [[ $host_mask -eq 0 ]] || [[ $host_mask -eq 24 ]]; then
			mask_cidr="/24"
		elif [[ $host_mask -eq 248 ]] || [[ $host_mask -eq 29 ]]; then
			mask_cidr="/29"
		elif [[ $host_mask -eq 252 ]] || [[ $host_mask -eq 30 ]]; then
			mask_cidr="/30"
	else 
			echo -e "${VERMELHO}\nO valor inserido não corresponde a um valor válido.\n${SEM_COR}"
	fi

	gateway="$network.$(( $host + 1))" # gateway da rede
	bh1="$network.$(( $host + 2))" # ip do bh1
	bh2="$network.$(( $host + 3))" # ip do bh2
	return 0
}

testa_bloco () { # verifica se o bloco utilizado estará livre.
	if ping -c 1 -W 1 "$gateway" &> /dev/null; then
			echo -e "\n${AMARELO}[ATENÇÃO]${SEM_COR} O IP $gateway está respondendo a ICMP."
		elif ping -c 1 -W 1 "$network" &> /dev/null; then
			echo -e "\n${AMARELO}[ATENÇÃO]${SEM_COR} O IP $network está respondendo a ICMP."
		elif ping -c 1 -W 1 "$bh1" &> /dev/null; then
			echo -e "\n${AMARELO}[ATENÇÃO]${SEM_COR} O IP $bh1 está respondendo a ICMP."
		elif ping -c 1 -W 1 "$bh2" &> /dev/null; then
			echo -e "\n${AMARELO}[ATENÇÃO]${SEM_COR} O IP $bh2 está respondendo a ICMP."
	else
				echo -e "\n${VERDE}O bloco está livre.${SEM_COR}\n"
			sleep 1
	fi
		GATEWAY="$network.$(( $host + 1))$mask_cidr"
		BH1="$network.$(( $host + 2))$mask_cidr"
		BH2="$network.$(( $host + 3))$mask_cidr"
}


ptp_tipo_pppoe () {
			# -------------------------------------------------------------------- INTERAÇÕES COM O USUÁRIO )
			echo "- Digite o ID do Contrato do cliente?"; read "ID"		
			echo "- Qual o login do PPPoE do cliente?"; read "LOGIN"		
			echo -e "- Qual a senha do PPPoE do cliente?"; read "SENHA"		
			identifica_bloco
			testa_bloco
			echo -e "\nDeseja adicionar usuário e senha padrão ou custom?\n${VERMELHO}(também será removido o usuário admin)${SEM_COR}\n"
			adicionar_usuario_mk
			echo -e "Deseja setar o L2MTU no máximo? (recomendado)"
			seta_max_l2mtu
			echo -e \
	"
	------- CONFIRA AS INFORMAÇÕES --------

	ID DO CLIENTE:${VERMELHO}  $ID ${SEM_COR}
	LOGIN DO PPPOE:${VERMELHO} $LOGIN ${SEM_COR}
	SENHA DO PPPOE:${VERMELHO} $SENHA ${SEM_COR}
	GATEWAY DO BH1:${VERMELHO} $GATEWAY ${SEM_COR}
	BLOCO DO BH1:${VERMELHO}   $BH1 ${SEM_COR}
	USUÁRIO: ${VERMELHO}$adicionar_usuario${SEM_COR}
	L2MTU: ${VERMELHO}$set_l2mtu${SEM_COR}

	---------------------------------------
	"
	PS3="$RODAPE2" # ------------------------------------------- RODAPÉ )
			select STATUS1 in "Sim!" "Não." #  ----------------------------------- ( SELEÇÃO DE CONFIMAÇÃO SIM OU NÃO )
			do
					case $STATUS1 in
					Sim! )
						ptp_pppoe_bh1 #EXPORTA BH1
						ptp_pppoe_bh2 #EXPORTA BH2
						echo -e "${VERDE}\nScript do BH1 e BH2 exportado com sucesso!${SEM_COR}"
							break
							;;
					Não. ) 
						echo -e "\nTente novamente! Saindo.....\n"
						sleep 2
						exit 1
							;;
					* )
						echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
							;;
				esac
			done
}



ptp_tipo_bridge () {
		echo "- Qual é o nome da localidade?"; read "LOCAL"
		identifica_bloco
		testa_bloco
		echo -e "\nDeseja adicionar usuário e senha padrão ou custom?\n${VERMELHO}(também será removido o usuário admin)${SEM_COR}\n"
		adicionar_usuario_mk
		echo -e "Deseja setar o L2MTU no máximo? (recomendado)"
		seta_max_l2mtu
	# CONFIRA SE AS INFORMAÇÕES ESTÃO CERTAS
		echo -e \
	"
	------- CONFIRA AS INFORMAÇÕES --------

	NOME DO BH1: BH1-${VERMELHO}$LOCAL${SEM_COR}-ARAUJOSAT
	NOME DO BH2: BH2-${VERMELHO}$LOCAL${SEM_COR}-ARAUJOSAT
	GATEWAY:   ${VERMELHO}$GATEWAY${SEM_COR}
	IP DO BH1: ${VERMELHO}$BH1${SEM_COR}
	IP DO BH2: ${VERMELHO}$BH2${SEM_COR}
	USUÁRIO: ${VERMELHO}$adicionar_usuario${SEM_COR}
	L2MTU: ${VERMELHO}$set_l2mtu${SEM_COR}

	---------------------------------------
	"
	PS3="$RODAPE2" # ----------------------- FRASE DO RODAPÉ )

	select STATUS2 in "Sim!" "Não."
	do
		case $STATUS2 in
			Sim! )
				ptp_bridge_bh1 #EXPORTA BH1
				ptp_bridge_bh2 #EXPORTA BH2
				echo -e "${VERDE}\nScript do BH1 e BH2 exportado com sucesso!${SEM_COR}"
					break
					;;
			Não. ) 
				echo -e "\nTente novamente! Saindo....."
				sleep 2
				exit 1
					;;
			* ) 
				echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
					;;
		esac
	done
}



