#
# Cookbook Name:: std_mysql
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
# A simple recipe to install the MySQL database on a Linux (CentOS) server
# within the SoftLayer Cloud.
#

package 'Install MySQL' do
   package_name 'mysql-server'
   action :install
end

service 'mysqld' do
   action [ :enable, :start ]
end

#
# EJK - Lets set up the secure installation for MySQL using a script
#

bash "configure MySQL" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      /usr/bin/mysql_secure_installation <<_EOT

Y
password
password
Y
Y
Y
Y
_EOT
   EOC
   not_if "ls /root/.mysql_secure_has_run"
end

file "/root/.mysql_secure_has_run" do
   action :create_if_missing
end
