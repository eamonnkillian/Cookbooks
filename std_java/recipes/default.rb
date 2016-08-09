#
# Cookbook Name:: std_java
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
# A simple recipe to install the current Java release on a Linux (CentOS) server
# within the SoftLayer Cloud.
#

pkg_server = "http://10.164.91.13/files/JAVA/"
pkg = "jdk-8u101-linux-x64.rpm"

bash "get java" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{pkg}"
   EOC
   not_if "ls /usr/bin/java"
end

bash "install java" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      rpm -ivh #{pkg}
   EOC
   not_if "ls /usr/bin/java"
end

bash "add java to path" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      echo "export PATH=$PATH:/usr/java/latest/bin" >> ~root/.bash_profile
      echo "export PATH" >> ~root/.bash_profile
      echo "set JAVA_HOME=/usr/java/latest" >> ~root/.bash_profile
   EOC
   not_if 'cat /root/.bash_profile | grep "JAVA_HOME"'
end

file "/root/jdk-8u101-linux-x64.rpm" do
   action :delete
end
