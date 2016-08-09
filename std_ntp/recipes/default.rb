#
# Cookbook Name:: std_ntp
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
# A simple recipe to make sure that the NTP daemon is running on a server and 
# to have it synchronising to the SoftLayer internal networks NTP servers. This
# program uses a template based ERB file (that will require curation over time) 
# as the ntp.conf file to be used on servers within a customers SoftLayer 
# environment.
#

package 'Install NTP' do
   package_name 'ntp'
   action :install    
end 

template "/etc/ntp.conf" do
	source "ntp.erb"
	mode "0644"
end

service "ntpd" do
   action [ :enable, :start ]
end

