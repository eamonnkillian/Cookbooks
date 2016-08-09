#
# Cookbook Name:: std_django
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
# A very simple recipe to install a Django development environment for web
# programmers/developers on SoftLayer servers.
# 
# Pre-requisites:
# 1) Install the development tools from recipe std_devtools; 
# 2) Install the Python 3.5.2 language from recipe std_python352;
# 3) Install the MySQL or MariaDB database from recipe std_mysql or std_mariadb;
# 4) Install the Apache web server from recipe std_apache;
# 5) Install the EPEL libraries from recipe std_epel.
# 

package 'Mod WSGI' do
   package_name 'mod_wsgi'
   action :install
end 

bash 'Install Django' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      pip install django
   EOC
   not_if "pip list | grep Django"
end
