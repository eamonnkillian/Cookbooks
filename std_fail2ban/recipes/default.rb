#
# Cookbook Name:: std_fail2ban
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
# A very simple recipe to install the fail2ban package onto the node. Fail2ban
# is a log parsing application that runs through the system logs isolating out
# certain events - in particular failed logins - and then enacts a new banning
# firewall rule using iptables to ban that host/IP from trying to connect to 
# the server. This is particularly useful in stopping troll attacks on port 22
# for ssh and for stopping brute force login attempts.
# 
# Dependencies: 
#
# 1) You must have the EPEL extensions installed.
#

package 'Install fail2ban' do
   package_name 'fail2ban'
   action :install
end

template '/etc/fail2ban/jail.local' do
   source 'jail.erb'
   mode '0644'
end

service 'fail2ban' do
   action [ :enable, :start ]
end
