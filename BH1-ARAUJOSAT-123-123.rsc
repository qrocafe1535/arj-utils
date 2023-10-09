
/
/interface bridge add name=bridge1
/interface wireless set [ find default-name=wlan1 ] band=5ghz-a/n channel-width=20/40mhz-XX country=no_country_set disabled=no frequency=5500 frequency-mode=superchannel mode=bridge nv2-preshared-key=bh1#123 nv2-security=enabled ssid=BH1-ARAUJOSAT-123 wireless-protocol=nv2 wps-mode=disabled
/interface wireless set [ find default-name=wlan1 ] disabled=no
/interface bridge port add bridge=bridge1 interface=wlan1
/interface bridge port add bridge=bridge1 interface=[/interface ethernet find default-name=ether1]
/ip address add address=1 interface=bridge1
/ip route add distance=254 gateway=123
/ip service set winbox port=47569
/system identity set name=BH1-ARAUJOSAT-123
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

