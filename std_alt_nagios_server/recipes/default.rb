#
# Cookbook Name:: std_alt_nagios_server
# Recipe:: default
# Author:: EJK
# License: MIT License
# Copyright (c)2016, SaaSify Limited, EJK
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
# following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#
# Description:
#
# A simple recipe to install the Nagios 3.5.1 monitoring server on a SoftLayer server. Nagios
# is a popular, free, open source application that monitors systems, networks and your
# whole infrastructure in your Cloud.
#
# Pre-requisites:
# 1) Internet access to get the packages;
# 2) Install the development tools from recipe std_devtools; 
# 3) Install the EPEL libraries from recipe std_epel;
# 4) Install the Apache web server from recipe std_apache;
# 5) Install the Devtools Extra from recipe std_devtools_extra. 
#

%w(
   nagios-common.x86_64
   nagios-plugins.x86_64
   nagios-plugins-nrpe.x86_64
   nagios.x86_64
   nagios-devel.i686
   nagios-devel.x86_64
   nagios-lcgdm.x86_64
   nagios-plugins-all.x86_64
   nagios-plugins-apt.x86_64
   nagios-plugins-bdii.x86_64
   nagios-plugins-bonding.x86_64
   nagios-plugins-breeze.x86_64
   nagios-plugins-by_ssh.x86_64
   nagios-plugins-check-updates.x86_64
   nagios-plugins-cluster.x86_64
   nagios-plugins-dbi.x86_64
   nagios-plugins-dhcp.x86_64
   nagios-plugins-dig.x86_64
   nagios-plugins-disk.x86_64
   nagios-plugins-disk_smb.x86_64
   nagios-plugins-dns.x86_64
   nagios-plugins-dpm-disk.x86_64
   nagios-plugins-dpm-head.x86_64
   nagios-plugins-dummy.x86_64
   nagios-plugins-file_age.x86_64
   nagios-plugins-flexlm.x86_64
   nagios-plugins-fping.x86_64
   nagios-plugins-fts.noarch
   nagios-plugins-game.x86_64
   nagios-plugins-hpjd.x86_64
   nagios-plugins-http.x86_64
   nagios-plugins-icmp.x86_64
   nagios-plugins-ide_smart.x86_64
   nagios-plugins-ifoperstatus.x86_64
   nagios-plugins-ifstatus.x86_64
   nagios-plugins-ircd.x86_64
   nagios-plugins-lcgdm.x86_64
   nagios-plugins-lcgdm-common.x86_64
   nagios-plugins-ldap.x86_64
   nagios-plugins-lfc.x86_64
   nagios-plugins-load.x86_64
   nagios-plugins-log.x86_64
   nagios-plugins-mailq.x86_64
   nagios-plugins-mrtg.x86_64
   nagios-plugins-mrtgtraf.x86_64
   nagios-plugins-mysql.x86_64
   nagios-plugins-nagios.x86_64
   nagios-plugins-nt.x86_64
   nagios-plugins-ntp.x86_64
   nagios-plugins-ntp-perl.x86_64
   nagios-plugins-nwstat.x86_64
   nagios-plugins-openmanage.x86_64
   nagios-plugins-oracle.x86_64
   nagios-plugins-overcr.x86_64
   nagios-plugins-perl.x86_64
   nagios-plugins-pgsql.x86_64
   nagios-plugins-ping.x86_64
   nagios-plugins-procs.x86_64
   nagios-plugins-radius.x86_64
   nagios-plugins-real.x86_64
   nagios-plugins-rhev.noarch
   nagios-plugins-rpc.x86_64
   nagios-plugins-sensors.x86_64
   nagios-plugins-smtp.x86_64
   nagios-plugins-snmp.x86_64
   nagios-plugins-ssh.x86_64
   nagios-plugins-swap.x86_64
   nagios-plugins-tcp.x86_64
   nagios-plugins-time.x86_64
   nagios-plugins-ups.x86_64
   nagios-plugins-uptime.x86_64
   nagios-plugins-users.x86_64
   nagios-plugins-wave.x86_64
  ).each do |pkg|
    package pkg do
      action :install
    end
  end

template '/etc/httpd/conf.d/nagios.conf' do
   source 'nagios.erb'
   mode 0644
end

ip_addr = node['ipaddress']

bash "add ip to conf" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      htpasswd -cb /etc/nagios/passwd nagiosadmin passw0rd
   EOC
end

service 'httpd' do
   action :restart
end

service 'nagios' do 
   action :restart
end
