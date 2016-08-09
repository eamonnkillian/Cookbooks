#
# Cookbook Name:: std_oracle_extra_fs
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
# A simple recipe to format an additional SAN disk and make a filesystem on that 
# disk for Oracle before the installation.
#
# Pre-requisites:
# 1) Make sure to order a virtual machine (or bare metal) with an additional SAN disk;
#

new_disk = "/dev/xvdc"
mount_point = "/oracle"

bash 'format disk' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      fdisk #{new_disk} <<_END
      n
      p
      1
      1
      
      p
      w
      _END
   EOC
   not_if "mount | grep oracle"
end

directory '/oracle' do
   action :create
   mode '0755'
end

bash 'make filesystem' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      mkfs.ext4 #{new_disk}
      mount #{new_disk} #{mount_point}
      echo "#{new_disk} #{mount_point} ext4 defaults 1 2" >> /etc/fstab
   EOC
   not_if "mount | grep oracle"
end

