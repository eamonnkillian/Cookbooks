#
# Cookbook Name:: std_webservice
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
# A simple recipe to install and configure an internal web service machine in SoftLayer 
# to hold packages and scripts for configuring machines in SoftLayer.
#

package "install mod ssl" do
   package_name 'mod_ssl' 
   action :install
end

package "install Open SSL" do
   package_name 'openssl' 
   action :install
end

bash "get java" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      openssl genrsa -out ca.key 2048
      openssl req -new -key ca.key -out ca.csr <<EOT
GB
London
London
IBM
Cloud
bartest.test.co.uk
.
.
.
EOT
      openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt
      cp ca.crt /etc/pki/tls/certs
      cp ca.key /etc/pki/tls/private/ca.key
      cp ca.csr /etc/pki/tls/private/ca.csr
      sed -i "s/localhost.crt/ca.crt/g" /etc/httpd/conf.d/ssl.conf
      sed -i "s/localhost.key/ca.key/g" /etc/httpd/conf.d/ssl.conf
   EOC
   not_if "ls /etc/pki/tls/private | grep 'ca.csr'"
end

service 'httpd' do
   action [ :enable, :restart ]
end
