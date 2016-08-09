#
# Cookbook Name:: std_wordpress
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
# A simple recipe to install the Wordpress environment on a Linux (CentOS) server
# within the SoftLayer Cloud.
#
# Pre-requisites:
# You should have used the standard recipes to create a LAMP stack or ordered a pre-built
# LAMP stack machine from SoftLayer. If using the Chef 'std_*' recipes make sure the following
# have run:
#
# 1) std_apache;
# 2) std_php5;
# 3) std_mysql or std_mariadb.
#

template '/tmp/wp.sql' do
   source 'wp.erb'
   mode '0644'
end

bash 'add wp database' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      mysql -u root --password=password < /tmp/wp.sql
   EOC
   not_if "ls /root/.wp_install_has_run"
end

pkg_server = "http://10.164.91.13/files/WORDPRESS/"
pkg = "latest.tar.gz"

bash 'get wordpress' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{pkg}"
   EOC
   not_if "ls /root/#{pkg}"
end

bash 'add wordpress' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      tar -xvf #{pkg}
      cp -Rf wordpress /var/www/html/
      chown -R apache:apache /var/www/html
   EOC
   not_if "ls /var/www/html/wordpress"
end

file "/root/.wp_install_has_run" do
   action :create_if_missing
end

service 'httpd' do
   action :restart
end
