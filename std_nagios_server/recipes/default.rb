#
# Cookbook Name:: std_nagios_server
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
# A simple recipe to install the Nagios 4.1.1 monitoring server on a SoftLayer server. Nagios
# is a popular, free, open source application that monitors systems, networks and your
# whole infrastructure in your Cloud.
#
# Pre-requisites:
# 1) An internal web server with the Python & Nagios packages or Internet access to get the packages;
# 2) Install the development tools from recipe std_devtools; 
# 3) Install the Python 3.3.3 or 3.5.2 package from recipes std_python333 or std_python352;
#

group 'nagcmd' do
   action :create
end

user 'nagios' do
   comment 'Nagios User'
   home '/home/nagios'
   shell '/bin/bash'
   password '<create password with openssh>'
   group 'nagcmd'
end

pkg_server = node['pkg_server']
pkg = node['nagios_pkg']
pkg_plugins = node['plugins_pkg']
pkg_dir = node['pkg_dir']
plugins_dir = node['plugins_dir']

bash "get nagios" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{pkg}"
      tar -zxvf #{pkg}
   EOC
   not_if "ls /usr/local/nagios"
end

bash "install nagios" do
   cwd "/root/#{pkg_dir}"
   user 'root'
   group 'root'
   code <<-EOC
      ./configure --with-command-group=nagcmd
      make all
      make install
      make install-init
      make install-config
      make install-commandmode
      sed -i "s/nagios@localhost/root@localhost.com/g" /usr/local/nagios/etc/objects/contacts.cfg 
      make install-webconf
      htpasswd -cb /usr/local/nagios/etc/htpasswd.users nagiosadmin passw0rd
      service httpd restart
   EOC
   not_if "ls /usr/local/nagios"
end

bash "get nagios plugins" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{pkg_plugins}"
      tar -zxvf #{pkg_plugins}
   EOC
   not_if "ls /root/#{pkg_plugins}"
end

bash "install nagios plugins" do
   cwd "/root/#{plugins_dir}"
   user 'root'
   group 'root'
   code <<-EOC
      ./configure --with-nagios-user=nagios --with-nagios-group=nagios
      make
      make install
      chkconfig --add nagios
      chkconfig nagios on
      chkconfig --add httpd
      chkconfig httpd on
   EOC
   not_if "ls /root/.nagios_plugins_has_run"
end

file "/root/.nagios_plugins_has_run" do
   action :create_if_missing
end

service "httpd" do
    action :restart
end

service "nagios" do
    action [ :enable, :restart ]
end
