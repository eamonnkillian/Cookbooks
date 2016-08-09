#
# Cookbook Name:: std_oracle_prerequisites
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
# A simple recipe to install the recommended Oracle pre-requisite packages before 
# installing Oracle on a bare metal or virtual machine within the SoftLayer Cloud. 
#

%w(
   elfutils-devel
   gcc
   gcc-c++
   glibc
   glibc-devel
   libaio-devel
   libaio
   libstdc++
   libtool-ltdl
   nss-softokn-freebl
   readline
   ncurses-libs
   libcap
   libattr
   compat-libcap1
   xterm
   ksh
   bzip2
   compat-libstdc++-33
  ).each do |pkg|
    package pkg do
      action :install
    end
  end

#
# EJK - Some issues have been experienced during Oracle install with this rpm
# so just in case the rpm is held on the web service server in the Oracle directory.
# We can manually install just in case there was an error for CentOS by uncommenting
# the following lines and making sure the package exists on the internal web server.
#
#
#pkg_server = node['oraclefiles']
#pkg = node['compatrpm']
#
#bash "install compat rpm" do
#   user 'root'
#   group 'root'
#   code <<-EOC
#      wget "#{pkg_server}#{pkg}"
#      rpm -Uvh "#{pkg}"
#   EOC
#   not_if "yum list installed | grep 'compat-libstdc++'"
#end

