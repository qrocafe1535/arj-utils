
/
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 disabled=no interface=wlan1 name=pppoe-out-AraujoSat password=123 use-peer-dns=yes user=123
/interface wireless set [ find default-name=wlan1 ] band=5ghz-a/n channel-width=20/40mhz-XX disabled=no frequency=5500 frequency-mode=superchannel country=no_country_set mode=station-bridge nv2-preshared-key=bh1#123 nv2-security=enabled scan-list=default,5100-6000 ssid=BH1-ARAUJOSAT-123 wireless-protocol=nv2
/interface wireless set [ find default-name=wlan1 ] disabled=no
/ip address add address=192.168.1.1/24 interface=[/interface ethernet find name=ether1] network=192.168.1.0
/ip firewall nat add action=masquerade chain=srcnat out-interface=pppoe-out-AraujoSat src-address=192.168.1.0/24
/ip firewall nat add action=dst-nat chain=dstnat dst-port=8080 in-interface=pppoe-out-AraujoSat protocol=tcp to-addresses=192.168.1.10 to-ports=8080
/system identity set name=BH2-ARAUJOSAT-123
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
/radius add address=10.51.200.2 comment=HEXANETWORKS secret="}grZ6@Y#(fv1dV)@(gQz" service=login timeout=1s
/radius incoming set accept=yes
/snmp set enabled=yes trap-version=2
/system logging action set 3 remote=10.51.200.3 remote-port=32514
/system logging set 0 topics=info,!account
/system logging add action=remote topics=critical
/system logging add action=remote topics=error
/system logging add action=remote topics=info
/system logging add action=remote topics=warning
/user aaa set interim-update=3m use-radius=yes
/user add group=full address=186.249.81.30 name=sup@sat password="lRz\$&1hd=vW+yD1kw32sH7qC+e\$ONnHN.6qs+Ri}"
/user remove admin
//int ethernet set l2mtu=20000 [f]
/

