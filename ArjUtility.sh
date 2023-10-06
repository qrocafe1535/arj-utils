#!/usr/bin/env bash

# Esse script foi criado com a finalidade de automatizar diversos dos processos do dia a dia no suporte técnico.
# Sinta-se livre para modificar e utilizar da forma que quiser!


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
                                                                            by Matheus
"

clear
echo "$LOGO_ARJ"

# ------------------------------------------- ( SELECIONA O TIPO DO SERVIÇO DESEJADO )
# FRASE DO RODAPÉ
PS3="


------- Selecione o que deseja: "

select ptp in "Gerar PTP para Cliente" "Gerar PTP para Backbone" "Manutenção BKP Antenas Ubiquit" "Sair"
	do
	case $ptp in
			"Gerar PTP para Cliente" )
				tipo="ptp-cliente"
					clear
					echo \
					"$LOGO_ARJ"
				break
				;;
			"Gerar PTP para Backbone" )
				tipo="ptp-backbone"
					clear
					echo \
					"$LOGO_ARJ"
				break
				;;
			"Manutenção BKP Antenas Ubiquit" )
				tipo="ubiquit"
					clear
					echo \
					"$LOGO_ARJ"
				break
				;;
			"Sair" )
				clear
				exit
				;;
			*) 
				echo "Comando não identificado!"
				;;
	esac
done
# FINAL DA SELEÇÃO DO SERVIÇO DESEJADO --------------------------#


# PONTO A PONTO DE CLIENTE -----------------------------------#

if [[ "$tipo" = "ptp-cliente" ]]; then
# ESCOLHA O ID DO CLIENTE
	echo \
	"- Digite o ID do Contrato do cliente?"
		read "ID"
# ESCOLHA O LOGIN DO PPPOE DO CLIENTE
	echo  \
	"- Qual o login do PPPoE do cliente?"
		read "LOGIN"
#ESCOLHA A SENHA DO PPPOE
	echo -e \
	"- Qual a senha do PPPoE do cliente?"
		read "SENHA"
# ESCOLHA O BLOCO QUE SERÁ ALOCADO PARA O BH1
	echo -e \
	"- Qual o bloco de ip do BH1? \nLembre-se de adicionar a mascara de subrede. \nFormato: XX.XX.XX.XX/MM"
		read "BLOCO"
#  QUAL O GATEWAY QUE O BH1 UTILIZARÁ COMO GATEWAY
	echo -e \
	"- Qual o gateway desse bloco? \nLembre-se de adicionar a mascara de subrede. \nFormato: XX.XX.XX.XX"
		read "GATEWAY"

## DEFINA O LOGIN  E A SENHA DO BH1 E BH2
#	echo \
#	"- Qual o usuário de acesso ao ponto a ponto?"
#		read "USER"
#	
#	echo \
#	"- Qual a senha de acesso ao ponto a ponto?"
#		read "PASSWORD"

echo \
"
------- CONFIRA AS INFORMAÇÕES --------

ID DO CLIENTE:  $ID
LOGIN DO PPPOE: $LOGIN
SENHA DO PPPOE: $SENHA
BLOCO DO BH1:   $BLOCO
GATEWAY DO BH1: $GATEWAY

---------------------------------------
"
# RODAPÉ -----------------------------------)
PS3=\
"
------- As informações estão corretas?: "

#  ----------------------------------- ( SELEÇÃO DE CONFIMAÇÃO SIM OU NÃO )
select STATUS1 in "SIM!" "NÃO."
do
	case $STATUS1 in
	SIM! )
#----------------------------------- ( EXPORTA PARA UM ARQUIVO DE BACKUP )
#------- EXPORTA BH1 
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
/radius add address=10.51.200.2 comment=HEXANETWORKS secret=$SECRET service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/	
" > "BH1-ARAUJOSAT-${LOGIN}-${ID}.rsc"

#------- EXPORTA BH2-CPE-CLIENTE.
# secret do radius.
SECRET='"}grZ6@Y#(fv1dV)@(gQz"'
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
/radius add address=10.51.200.2 comment=HEXANETWORKS secret=$SECRET service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/
" > "BH2-ARAUJOSAT-${LOGIN}-${ID}.rsc"

echo -e \
	"\nScript do BH1 e BH2 exportado com sucesso!"
break
;;
			
			NÃO. ) 
				echo -e "\nTente novamente! Saindo....."
			exit
				;;
			* )
				echo -e "\nPor favor insira uma opção válida."
				;;
esac
done

fi


# FINAL DO SCRIPT Gerar PTP para Cliente DEDICADO -------------------------------------#

if [[ "$tipo" = "ptp-backbone" ]]; then
	echo \
	"- Qual é o nome da localidade?"
		read "LOCAL"

	echo -e \
	"- Qual é o ip do BH1? \nLembre-se de adicionar a mascara de subrede. \nFormato: XX.XX.XX.XX/MM"
		read "BH1"
	echo -e \
	"- Qual é o ip do BH2? \nLembre-se de adicionar a mascara de subrede. \nFormato: XX.XX.XX.XX/MM"
		read "BH2"
	echo -e \
	"- Qual o gateway do ponto a ponto? \nLembre-se de adicionar a mascara de subrede. \nFormato: XX.XX.XX.XX"
		read "GATEWAY"

## DEFINA O LOGIN  E A SENHA DO BH1 E BH2
#	echo -e \
#	"- Qual usuário de acesso? \nLembrando que também será adicionado o radius."
#		read "USER"
#	echo \
#	"- Qual a senha de acesso?"
#		read "PASSWORD"

echo \
"
------- CONFIRA AS INFORMAÇÕES --------

NOME DO BH1: BH1-$LOCAL-ARAUJOSAT
NOME DO BH2: BH2-$LOCAL-ARAUJOSAT
IP DO BH1: $BH1
IP DO BH2: $BH2
GATEWAY:   $GATEWAY

---------------------------------------
"

PS3=\
"
------- As informações estão corretas?: "

select STATUS2 in "SIM!" "NÃO."
do
	case $STATUS2 in
		SIM! )
# secret do radius.
SECRET='"}grZ6@Y#(fv1dV)@(gQz"'
			echo \
"
/
/interface bridge add name=bridge1
/interface wireless set [ find default-name=wlan1 ] band=5ghz-n/ac channel-width=20/40-XX country=no_country_set disabled=no frequency=5500 frequency-mode=superchannel mode=bridge nv2-preshared-key=bh#$LOCAL nv2-security=enabled ssid=BH1-$LOCAL wireless-protocol=nv2 wps-mode=disabled
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
/radius add address=10.51.200.2 comment=HEXANETWORKS secret=$SECRET service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/			
" > "BH1-${LOCAL}-ARAUJOSAT.rsc"


#----------------------------- (EXPORTA BH2-CPE-CLIENTE.)
			echo \
"

/
/interface bridge add name=bridge1
/interface wireless set [ find default-name=wlan1 ] band=5ghz-a/n/ac channel-width=20/40mhz-XX country=no_country_set disabled=no frequency-mode=superchannel mode=station-bridge nv2-preshared-key=bh#$LOCAL nv2-security=enabled radio-name=BH2-$LOCAL scan-list=default,5100-6000 ssid=BH1-$LOCAL wireless-protocol=nv2
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
/radius add address=10.51.200.2 comment=HEXANETWORKS secret=$SECRET service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/			
" > "BH2-${LOCAL}-ARAUJOSAT.rsc"
				break
					;;

			NÃO. ) 
				echo "Tente novamente! Saindo....."
				exit
					;;
			* ) 
				echo "Por favor insira uma opção válida."
					;;
	esac
done
fi



if [[ "$tipo" = "ubiquit" ]]; then #--------------------------------------------------- ( COMEÇA MANUTENÇÃO UBQUIT )

PS3="


------- Selecione o que deseja: "

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
				exit
				;;
			* ) 
					echo "Por favor insira uma opção válida."
						;;
			
		esac
	done

	#-------------------------------------------------------- ( Selecionou Gerar BKP para Antena Ubiquit )
	if [[ "$MANUBQUIT" = "Gerar BKP para Antena Ubiquit" ]]; then

		echo \
			"Qual o nome do painel?"
			read "NOME"  
		echo \
			"Qual o SSID que deseja propagar?"
			read "SSID"  
		echo \
			"Qual WPA do painel?"
			read "WPA" 
		echo -e \
			"Qual o IP do pinel? \nUtilizar o formato XX.XX.XX.XX"
			read "IP" 
		echo -e \
			"Qual a mascara? \nUtilizar o formato XX.XX.XX.XX"
			read "MASK" 		
		echo -e \
			"Qual o IP do gateway? \nUtilizar o formato XX.XX.XX.XX"
			read "GATEWAY" 		
		echo \
"
------- CONFIRA AS INFORMAÇÕES --------

NOME: $NOME
SSID: $SSID
WPA: $WPA
IP: $IP
MASCARA: $MASK	
GATEWAY: $GATEWAY

---------------------------------------
"
# RODAPÉ -----------------------------------)
PS3=\
"
------- As informações estão corretas?: "


		select STATUS3 in "Sim!" "Não." #----------------------------- (SELEÇÃO DE SIM OU NÃO)
			do
			case $STATUS3 in 
				"Sim!" ) #----------------------- (CASO SIM EXECUTE ABAIXO)
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
					echo "BKP exportado com sucesso!"
					break
					;;
				"Não." )
					echo -e "Tente novamente! \nSaindo..."
					break
					;;
				* )
					echo "Por favor insira uma opção válida."
					;;
				
			esac
			done
	
	fi


	#--------------------------------------------------- ( Download Atualização das Antenas v.6.3.11 )
	if [[ "$MANUBQUIT" = "Download Atualização das Antenas v.6.3.11" ]]; then

			echo "Realizando download dos arquivos direto da fabricante em ~/Downloads/ANTENAS-6.3.11!"			
			diretorio_destino="/home/$USER/Downloads/ANTENAS-6.3.11"
			mkdir -p "$diretorio_destino"  # -p para criar o diretório se ele não existir
			# baixando binários na pasta definida.
			echo "Binário XW"
			wget -P "$diretorio_destino" "https://dl.ui.com/firmwares/XW-fw/v6.3.11/XW.v6.3.11.33396.230425.1644.bin"
			echo "Binário XM"
			wget -P "$diretorio_destino" "https://dl.ui.com/firmwares/XN-fw/v6.3.11/XM.v6.3.11.33396.230425.1742.bin"
			echo "Download Finalizado com sucesso!!"
	fi

#---------------------------------------------------------------------------- (COMEÇA LISTA DE CANAIS)
	if [[ "$MANUBQUIT" = "Gerar lista de Canais" ]]; then 
		
		LISTACANAIS="

5180,5200,5220,5240,5260,5280,5300,5320,5340,5360,5380,5400,5420,5440,5460,5480,5500,5520,5540,5560,5580,5600,5620,5640,5660,5680,5700,5720,5725,5740,5745,5760,5765,5780,5785,5800,5805,5815,5820,5825,5840,5860,5880,5900

"

		echo \
		"$LISTACANAIS"
		echo \
		"Deseja que seja criado um arquivo contendo a lista?"
		select STATUSLISTA in "Sim!" "Não."
			do
			case $STATUSLISTA in
					"Sim!" )
						break
						;;
					"Não." )
						break
						;;
					*) 
						echo "Comando não identificado!"
						;;
			esac
		done

		if [[ "$STATUSLISTA" = "Sim!" ]]; then
			echo "$LISTACANAIS" > Lista_de_canais.txt
		
		if [[ "$STATUSLISTA" = "Não." ]]; then
			echo "Saindo!..."
			exit
		fi

		fi
	
	fi #--------------------------------------- (TERMINA LISTA DE CANAIS)


fi #-------------------------------------------------------------- ( TERMINA MANUTENÇÃO UBQUIT )
