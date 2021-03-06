#
# EJK - IPTables rules for a Private Network only web server 
#
default['base']['rules']['flush'] = '-F'
default['base']['rules']['input'] = '-P INPUT DROP'
default['base']['rules']['forward'] = '-P FORWARD DROP'
default['base']['rules']['output'] = '-P OUTPUT DROP'
default['base']['rules']['loopin'] = '-A INPUT --in-interface lo -j ACCEPT'
default['base']['rules']['loopout'] = '-A OUTPUT --out-interface lo -j ACCEPT'
default['base']['rules']['icmpin'] = '-A INPUT --in-interface eth0 -p icmp --icmp-type echo-request -m iprange --src-range 10.0.0.0-10.255.255.255 -j ACCEPT'
default['base']['rules']['icmpout'] = '-A OUTPUT --out-interface eth0 -p icmp --icmp-type echo-reply -j ACCEPT'
default['base']['rules']['icmpechoin'] = '-A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT'
default['base']['rules']['icmpechoout'] = '-A INPUT -p icmp --icmp-type echo-reply -j ACCEPT'
default['base']['rules']['sshin'] = '-A INPUT --in-interface eth0 -p tcp --dport 22 -j ACCEPT'
default['base']['rules']['sshout'] = '-A OUTPUT -p tcp --sport 22 -j ACCEPT'
default['base']['rules']['dnsout'] = '-A OUTPUT -p udp --out-interface eth0 --dport 53 -j ACCEPT'
default['base']['rules']['dnsin'] = '-A INPUT -p udp --in-interface eth0 --sport 53 -j ACCEPT'
default['base']['rules']['httpin'] = '-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT'
default['base']['rules']['httpsin'] = '-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT'
default['base']['rules']['ftpin'] = '-A INPUT -p tcp -m tcp --dport 20 -j ACCEPT'
default['base']['rules']['associatedin'] = '-A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT'
default['base']['rules']['associatedout'] = '-A OUTPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT'
default['base']['rules']['httpout'] = '-A OUTPUT -p tcp -m tcp -m state --state NEW --dport 80 -j ACCEPT'
default['base']['rules']['httpsout'] = '-A OUTPUT -p tcp -m tcp -m state --state NEW --dport 443 -j ACCEPT'
default['base']['rules']['ntpout'] = '-A OUTPUT -p udp --dport 123 -j ACCEPT'
default['base']['rules']['ntpin'] = '-A INPUT -p udp --sport 123 -j ACCEPT'
