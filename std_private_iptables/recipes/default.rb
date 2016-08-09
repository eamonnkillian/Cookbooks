#
# Cookbook Name:: std_private_iptables
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
# A very simple recipe to make set up the correct secure firewalling on machines
# within a private only network. This recipe ensures that:
# 
# - The default policy for input, forward and output is reset to DROP;
# - The loop back interface traffic is accepted;
# - Interface eth0 is allowed to send outbound pings;
# - Interface eth0 is allowed to receive inbound pings;
# - Interface eth0 is allowed to receive inbound SSH;
# - Interface eth0 is allowed to use DNS;
# - Interface eth0 is allowed to send & receive on ports 80, 443, 20 & 22
#
# This locks down the machine from malicious traffic. By changing the port for SSH
# in this file an alternate SSH port could be used. 
#

node[:base][:rules].each do |key,value|
   execute key do
      command "iptables #{value}"
   end
end

execute "iptables save" do
   command "service iptables save"
end

execute "iptables restart" do
   command "service iptables restart"
end 
