#
# Cookbook Name:: std_devtools_extra
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
# A simple recipe to install some additional packages required for installing Nagios. Use this
# if you are not upgrading/installing Python 3.3.3 or Python 3.5.2 as part of creating a Nagios
# server.
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

