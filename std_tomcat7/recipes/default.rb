#
# Cookbook Name:: std_tomcat7
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
# A simple recipe to install the Apache Tomcat web server.
#
# Pre-requisites:
# 1) Install Java from the recipe std_java
#

pkg_server = "http://mirror.catn.com/pub/apache/tomcat/tomcat-7/v7.0.70/bin/"
pkg = "apache-tomcat-7.0.70.tar.gz"
tomcat = "apache-tomcat-7.0.70"
tomlocal = "/usr/local/tomcat7"

bash "get tomcat" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{pkg}"
   EOC
   not_if "ls /usr/local/tomcat7"
end

bash "unpack tomcat" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      tar -xzf "#{pkg}"
      mv #{tomcat} #{tomlocal}
   EOC
   not_if "ls /usr/local/tomcat7"
end

template '/etc/init.d/tomcat' do
   source 'tomcat.erb'
   mode '0755'
   owner 'root'
   group 'root'
end

service 'tomcat' do
   action [ :start ]
end

file "/root/apache-tomcat-7.0.70.tar.gz" do
   action :delete
end
