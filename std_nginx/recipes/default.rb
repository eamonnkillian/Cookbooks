#
# Cookbook Name:: std_nginx
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
# A very simple recipe to install the nginx package onto the node. Nginx 
# is an alternate web server software. In addition to serving HTTP content 
# using FastCGI, SCGI and WSGI nginx is often deployed as a software load 
# balancer or reverse proxy to Node.js applications on the local node.
# 

package 'Install nginx' do
   package_name 'nginx'
   action :install
end

service 'nginx' do
   action [ :enable, :start ]
end
