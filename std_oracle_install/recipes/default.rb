#
# Cookbook Name:: std_oracle_install
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
# A simple recipe to install a test Oracle 11gR2 database server.
#
# Pre-requisites:
# The following recipes must have run successfully;
# 1) std_motd;
# 2) std_timezone;
# 3) std_yum;
# 4) std_admins;
# 5) std_oracle_extra_fs;
# 6) std_oracle_swap;
# 7) std_unix_odbc;
# 8) std_xwindows;
# 9) std_devtools;
# 10) std_devtools_extra;
# 11) std_oracle_kernel;
# 12) std_oracle_users.
# 

pkg_server = "http://<your servers IP>/files/ORACLE/"
oracle_pkg1 = "linux.x64_11gR2_database_1of2.zip"
oracle_pkg2 = "linux.x64_11gR2_database_2of2.zip"

directory '/oracle/tmp' do
   owner 'oracle'
   group 'oinstall'
   action :create
end

bash 'getting Oracle one' do
   cwd '/oracle/tmp'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{oracle_pkg1}"
   EOC
   not_if "ls /oracle/tmp/#{oracle_pkg1}"
end

bash 'getting Oracle two' do
   cwd '/oracle/tmp'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{oracle_pkg2}"
   EOC
   not_if "ls /oracle/tmp/#{oracle_pkg2}"
end

bash 'unzipping Oracle' do
   cwd '/oracle/tmp'
   user 'root'
   group 'root'
   code <<-EOC
      unzip "#{oracle_pkg1}"
      unzip "#{oracle_pkg2}"
   EOC
   not_if "ls /oracle/tmp/database"
end

execute 'change ownerships' do
   command "chown -R oracle:oinstall /oracle/tmp/database"
end

template '/oracle/tmp/database/oracle-response.rsp' do
   source 'oracle-response.erb'
   mode '0644'
   owner 'oracle'
   group 'oinstall'
end 

oraclehost = node['fqdn']
bash 'add hostname' do
   cwd '/oracle/tmp/database'
   user 'root'
   group 'root'
   code <<-EOC
      sed -i "s/XXXXXXXX/#{oraclehost}/g" oracle-response.rsp
   EOC
   not_if "grep #{oraclehost} oracle-response.rsp"
end

bash 'run oracle installer' do
   cwd '/oracle/tmp/database'
   user 'oracle'
   group 'oinstall'
   code <<-EOC
      /oracle/tmp/database/runInstaller -ignoreSysPrereqs -ignorePrereq -silent -nowelcome -nowait -responseFile /oracle/tmp/database/oracle-response.rsp
   EOC
   not_if "ls /oracle/app/oracle/product/11.2.0/dbhome_1/bin"
end
