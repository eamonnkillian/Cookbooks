#
# Cookbook Name:: std_python352
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
# A simple recipe to install the Python 3.5.2 programming language on a Linux server
# as an alternate install of the language. This is a non-destructive install - it will
# not remove the existing Linux versions embedded Python version (which is often 2.7.6).
# Another reason for having this recipe is that a Django service environment requires 
# Python 3.5.2 or later to work.
#
# Pre-requisites:
# 1) An internal web server with the Python packages or Internet access to get the packages;
# 2) Install the development tools from recipe std_devtools; 
#

%w(
   openssl-devel
   sqlite-devel
   bzip2-devel
   gcc
   glibc
   glibc-common
   make
   net-snmp
   httpd
   php
   gd
   gd-devel
   perl
   perl-devel
   unzip
  ).each do |pkg|
    package pkg do
      action :install
    end
  end

pkg_server = node['pkg_server']
pkg = node['python_pkg']
pkg_tar = node['python_tarball']
py_setup = node['python_setup']
py_pip = node['pip']
py_pip_whl = node['pip_whl']
py_pip_wheel = node['pip_wheel']

bash "get python" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{pkg}"
      xz -d "#{pkg}"
      tar -xvf #{pkg_tar}
   EOC
   not_if "ls /usr/local/bin/python3.5"
end

bash "install python" do
   cwd '/root/Python-3.5.2'
   user 'root'
   group 'root'
   code <<-EOC
      ./configure
      make
      make altinstall
   EOC
   not_if "ls /usr/local/bin/python3.5"
end

template '/root/.bashrc' do
   source 'bashrc.erb'
   mode '0644'
end

bash "install setuptools" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{py_setup}"
      tar -xvf "#{py_setup}"
      cd setuptools-25.1.2
      /usr/local/bin/python3.5 setup.py install
   EOC
   not_if "pip list | grep setuptools"
end

bash "install pip" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      wget "#{pkg_server}#{py_pip}"
      wget "#{pkg_server}#{py_pip_whl}"
      wget "#{pkg_server}#{py_pip_wheel}"
      /usr/local/bin/python3.5 get-pip.py --no-index --find-links=/root
   EOC
   not_if "pip list | grep setuptools"
end

bash "cleanup python" do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      rm -rf Pyth*
   EOC
end
