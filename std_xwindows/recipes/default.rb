#
# Cookbook Name:: std_xwindows
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
# A simple recipe to install the X windows environment to enable users and 
# admins to be able to use "ssh -X" and receive GUI windows back to their local
# machines from Linux hosts on the SoftLayer Cloud.
#

bash "yum groupinstall X Windows" do
   user 'root'
   group 'root'
   code <<-EOC
      yum -y groupinstall "X Window System"
   EOC
   not_if "yum grouplist installed | grep 'X Window System'"
end

bash "yum groupinstall base desktop" do
   user 'root'
   group 'root'
   code <<-EOC
      yum -y groupinstall "Desktop"
   EOC
   not_if "yum grouplist installed | grep 'Desktop'"
end

bash "yum groupinstall desktop platform" do
   user 'root'
   group 'root'
   code <<-EOC
      yum -y groupinstall "Desktop Platform"
   EOC
   not_if "yum grouplist installed | grep 'Desktop Platform'"
end

bash "yum groupinstall fonts" do
   user 'root'
   group 'root'
   code <<-EOC
      yum -y groupinstall "Fonts"
   EOC
   not_if "yum grouplist installed | grep 'Fonts'"
end
