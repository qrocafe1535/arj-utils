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
netconf.3.ip=$AP1
netconf.3.mtu=1500
netconf.3.netmask=$mask_cidr
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
resolv.host.1.name=$NOME
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
telnetd.port=23
telnetd.status=enabled
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


identifica_bloco_antena () {
    ip=$(gum input --placeholder "Qual o endereço de rede? X.X.X.X")
    mask=$(gum input --placeholder "Qual a mascara? Y")

# variaveis 
    network=$( echo "$ip" | cut -d "." -f1,2,3 ) # network ip
    host=$( echo "$ip" | cut -d "." -f4 ) # separa o ultimo octeto do host da rede
    host_mask=$( echo "$mask" | cut -d "." -f4 ) # separa o ultimo octeto da mascara da rede

    if [[ $host_mask -eq 252 ]] || [[ $host_mask -eq 30 ]]; then
        mask_cidr="255.255.255.252"
        gateway="$network.$(( $host + 1))" # gateway da rede
        ap1="$network.$(( $host + 2))" # ip do ap1
        return 0
    else 
        echo -e "${VERMELHO}\nO valor inserido não corresponde a um valor válido.${SEM_COR}\nSó serão aceitos blocos /30\n"
    fi

}

testa_bloco_antena () { # verifica se o bloco utilizado estará livre.
    if ping -c 1 -W 1 "$gateway" &> /dev/null; then
        echo -e "\n${AMARELO}[ATENÇÃO]${SEM_COR} O IP $gateway está respondendo a ICMP."
    elif ping -c 1 -W 1 "$network" &> /dev/null; then
        echo -e "\n${AMARELO}[ATENÇÃO]${SEM_COR} O IP $ap1 está respondendo a ICMP."
    else
        echo -e "\n${VERDE}O bloco está livre.${SEM_COR}\n"
        sleep 1
    fi
        GATEWAY="$network.$(( $host + 1))"
        AP1="$network.$(( $host + 2))"
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
    sleep 2
}

lista_de_canais () {
	echo \
"
5180,5200,5220,5240,5260,5280,5300,5320,5340,5360,5380,5400,5420,5440,5460,5480,5500,5520,5540,5560,5580,5600,5620,5640,5660,5680,5700,5720,5725,5740,5745,5760,5765,5780,5785,5800,5805,5815,5820,5825,5840,5860,5880,5900
"
}

gerar_config_painel () {
    NOME=$(gum input --placeholder "Qual o nome do painel?")
    SSID=$(gum input --placeholder "Qual o SSID que deseja propagar?")
    WPA=$(gum input --placeholder "Qual WPA do painel?")
    identifica_bloco_antena
    testa_bloco_antena
        gum style \
                    --foreground 212 --border-foreground 212 --border double \
                    --align left --width 40 --margin "1 1" --padding "1 3" \
"
NOME: $NOME
SSID: $SSID
WPA: $WPA
GATEWAY: $GATEWAY
IP: $AP1
MASCARA: $mask_cidr
"

gum confirm --affirmative="Sim" --negative="Não" "As informações estão corretas?" && gum spin --title "Exportando configuração..." sleep 2 && bkp_da_antena
}