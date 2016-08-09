#
# Cookbook Name:: std_oracle_users
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
# A simple recipe to add the required users for Oracle before installation.
#

group 'dba' do
   action :create
end

user 'oracle' do
   comment 'Oracle User'
   home '/home/oracle'
   shell '/bin/bash'
   password '<create password using openssh>'
   group 'dba'
end

group 'oinstall' do
   action :create
   members 'oracle'
end

directory '/oracle/app' do
   owner 'oracle'
   group 'dba'
end

template '/home/oracle/.bash_profile' do
   source 'bash_profile.erb'
   mode 0644
   owner 'oracle'
   group 'oinstall'
end
