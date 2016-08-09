#
# Cookbook Name:: std_cassandra
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
# A simple recipe to install a single node Cassandra cluster server on a CentOS 
# 6 Linux server within the SoftLayer Cloud. Cassandra is a free open source 
# distributed database management system specifically designed to manage very
# large data quantities across a large number of commodity machines. 
#
# Pre-requisites:
# The following recipes must have run successfully;
# 1) std_motd;
# 2) std_timezone;
# 3) std_yum;
# 4) std_admins;
# 5) std_java;
# 

group 'cassandra' do
   action :create
end

user 'cassandra' do
   comment 'Cassandra User'
   home '/home/cassandra'
   shell '/bin/bash'
   password '<make a password with openssh>'
   group 'cassandra'
end

pkg_server = "http://apache.mirror.anlx.net/cassandra/3.7/"
pkg = "apache-cassandra-3.7-bin.tar.gz"

bash 'get Cassandra' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{pkg}"
   EOC
   not_if "ls /home/cassandra/apache*"
end

bash 'get Cassandra' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      tar -zxvf "#{pkg}"
      mv apache* /home/cassandra/
      chown -R cassandra:cassandra /home/cassandra/
   EOC
   not_if "ls /home/cassandra/apache*"
end

bash "add java to path" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      echo "export PATH=$PATH:/usr/java/latest/bin" >> ~cassandra/.bash_profile
      echo "export PATH" >> ~cassandra/.bash_profile
      echo "set JAVA_HOME=/usr/java/latest" >> ~cassandra/.bash_profile
   EOC
   not_if 'cat ~cassandra/.bash_profile | grep "JAVA_HOME"'
end

file "/root/#{pkg}" do
   action :delete
end

file "/home/cassandra/#{pkg}" do
   action :delete
end
