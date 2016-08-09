#
# Cookbook Name:: std_bareos_srv
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
# A simple recipe to install a Backup Archiving Recovery Open Sourced (BareOS) 
# version 15.2 on a CentOS 6 Linux server within the SoftLayer Cloud. BareOS 
# provides a simple effective reliable and extremely cost effective solution 
# for cross-network heterogenous backing up of files, machines, shares etc. 
#
# Pre-requisites:
# The following recipes must have run successfully;
# 1) std_motd;
# 2) std_timezone;
# 3) std_yum;
# 4) std_admins;
# 5) std_epel;
# 6) std_apache;
# 7) std_mysql;
# 8) std_php5;
# 
# Critical:
#
# 1) In addition the machine procured on SoftLayer should have extensive additional 
#    disk space either locally or via Endurance storage mounted as /bareos on the 
#    server.
# 2) The std_mysql package installs the MySQL database with a root password of 
#    'password'. If you have changed this password then you must edit the file 
#    my-cnf.erb in the templates/default/ directory of this recipe before running
#    this recipe.
#

template '/etc/yum.repos.d/bareos.repo' do
   source 'bareos-repo.erb'
   mode '0644'
end 

template '/root/.my.cnf' do
   source 'my-cnf.erb'
   mode '0644'
end 

package 'Install BareOS' do
   package_name 'bareos'
   action :install
end

package 'Install BareOS Database' do
   package_name 'bareos-database-mysql'
   action :install
end

directory '/bareos' do
   action :create
   owner 'bareos'
   group 'bareos'
end

bash 'configure BareOS' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      /usr/lib/bareos/scripts/create_bareos_database
      /usr/lib/bareos/scripts/make_bareos_tables
      /usr/lib/bareos/scripts/grant_bareos_privileges
   EOC
   not_if "ls /root/.bareos_setup_has_run"
end

package 'Install BareOS WebGUI' do
   package_name 'bareos-webui'
   action :install
end

bash 'configure BareOS' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      echo "@/etc/bareos/bareos-dir.d/webui-consoles.conf" >> /etc/bareos/bareos-dir.conf
      echo "@/etc/bareos/bareos-dir.d/webui-profiles.conf" >> /etc/bareos/bareos-dir.conf
   EOC
   not_if 'cat /etc/bareos/bareos-dir.conf | grep "webui"'
end

template '/etc/bareos/bareos-dir.d/webui-consoles.conf' do
   source 'webui-consoles.erb'
   mode '0644'
   owner 'bareos'
   group 'bareos'
end

template '/etc/bareos/bareos-dir.d/webui-profiles.conf' do
   source 'webui-profiles.erb'
   mode '0644'
   owner 'bareos'
   group 'bareos'
end

service 'bareos-dir' do
   action :restart
end

service 'bareos-sd' do
   action :restart
end

service 'bareos-fd' do
   action :restart
end

service 'httpd' do
   action :restart
end 

file "/root/.bareos_setup_has_run" do
   action :create_if_missing
end
