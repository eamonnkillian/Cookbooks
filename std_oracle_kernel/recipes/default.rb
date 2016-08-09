#
# Cookbook Name:: std_oracle_kernel
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
# A simple recipe to install some additional files required for installing Oracle.
# Specifically the:
# 
# - The Linux kernel configuration parameters file "sysctl.conf";
# - The Pluggable Authentication Modules (PAM) limits file "limits.conf";
# - The Pluggable Authentication Modules (PAM) login file "login";
#

template '/etc/sysctl.conf' do
   source 'sysctl.erb'
   mode '0644'
end

template '/etc/security/limits.conf' do
   source 'limits.erb'
   mode '0644'
end 

template '/etc/pam.d/login' do
   source 'login.erb'
   mode '0644'
end

execute 'set kernel' do
   command '/sbin/sysctl -p'
end

#bash 'set kernel' do
#   cwd '/root'
#   user 'root'
#   group 'root'
#   code <<-EOC
#      sysctl -p
#   EOC
#end
