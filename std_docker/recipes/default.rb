#
# Cookbook Name:: std_docker
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
# Docker is a containerization platform. So what's a containerization platform? Well
# its best to start thinking of a container from the point of view of an application. 
# any app needs its run environment (the variables, patches, OS, libraries, packages,
# users and other considerations) to be able to execute the code. This environment
# needs to be set up on every single machine that the app will run on and in a 
# heterogeneous computing environment this can be costly overhead. Containers came to 
# life to solve this problem. The ability to easily move an app from one machine to 
# another is greatly enhanced if you could move the app with its environment parameters
# like it was a box and just place it on a vanilla computer of whatever OS and then it 
# would just run! Lets call that box a "container".  
#
# Docker advanced the containerization introduced by LXC technology and now provides a
# slick way to:
# 
# - abstract or disassociate the host system away from the container;
# - scale the app infintely (or big anyway) and easily;
# - bundle the app and all its dependencies easily;
# - isolate the app execution environment from other environments on the same host;
# - bring about sinple versioning of the container so you can manage the app and its 
#   environment as if it were code.
#
# Pre-requisites:
# 1) A CentOS 7 machine;
# 2) An external/pulic interface or the correct ports enabled on your Vyatta for Docker 
#    to pull images via your default gateway device.
#

template "/etc/yum.repos.d/docker.repos" do
	source "docker.erb"
	mode "0644"
end

package 'Install Docker Engine' do
   package_name 'docker-engine'
   action :install
end

service 'docker' do
   action [ :enable, :start ]
end
