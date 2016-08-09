#
# Cookbook Name:: std_oracle_swap
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
# A simple recipe to increase the size of the swap on a SoftLayer server to accommodate
# the required level to install Oracle.
# 

bash 'increase swap' do
   cwd '/root'
   user 'root'
   group 'root'
   code <<-EOC
      declare -i MEMINFO
      declare -i SWAPINFO
      MEMINFO=`cat /proc/meminfo | head -1 | awk '{print $2}'`
      SWAPINFO=`cat /proc/meminfo | grep SwapTotal | awk '{print $2}'`
      MEMTEST=$(($MEMINFO*2))
      if [ $SWAPINFO -lt $MEMTEST ]; then
         dd if=/dev/zero of=/swapfile bs=1024 count=$MEMTEST
         mkswap /swapfile
         swapon /swapfile
         cat /proc/meminfo
         echo "/swapfile	swap	swap	defaults	0 0" >> /etc/fstab
      fi
   EOC
   not_if "ls /swapfile"
end
