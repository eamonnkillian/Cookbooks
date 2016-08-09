#
# Cookbook Name:: std_admins
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
# During the successful bootstrapping of a Chef Node the 'chef-client' 
# program will utilize the 'first-run.json' file to receive either its
# 'role' with embedded recipes or a 'run_list' of specific recipes. 
# This recipe usually runs either (a) as part of the role assigned to 
# each machine or (b) as a standalone recipe in a 'run_list' for each
# node. The recipe itself is very simple - it will iterate through the 
# sysadmins 'data_bags' located on the Chef Server and find any entries
# that have an action of ':create'. Foreach of those entries the recipe
# will:
#
#   - create the local systems administration user;
#   - create their home directory;
#   - create a '.ssh' directory in the users home directory;
#   - add the 'authorized_keys' file to the '.ssh' directory;
#   - set the correct permissions on both;
#   - add the 'data_bag' attribute 'sshkeys' to the 'authorized_keys' file;
#   - check if the systems administration user is already in the '/etc/sudoers' file; and
#   - if they are not in the file then create the required entry to enable 'sudo' for the user.
#
# This means that sysadmin user control is achieved by simply adding a 
# 'data_bag' JSON file for any new user. Once the 'data_bag' is added the
# Chef convergence on every Chef Node within your environment will add the 
# required new systems administrator to the local machine.
#

#
# Lets use search to iterate through the data bags for sysadmins
# 

search(:sysadmins, "action:create").each do |data|
   user data["id"] do
      comment data["comment"]
      uid data["uid"]
      gid data["gid"]
      home data["home"]
      shell data["shell"]
      password data["password"]
   end

#
# Set two Ruby variables to use within the body of the script
#

   owner = data["id"]
   key = data["sshkeys"]

#
# Create the users .ssh directory and permission it correctly 
#

   directory "/home/#{owner}/.ssh" do
      mode '0700'
      owner "#{owner}"
   end

# 
# Create the authorized keys file and add the content from the 
# data_bag to it
#

   file "/home/#{owner}/.ssh/authorized_keys" do
      content "#{key}"
      owner "#{owner}"
      mode '0600'
   end

#
# Now we need to add the ability for each Systems Administrator to 
# become a "root" user on the machine.
#

   if not File.foreach("/etc/sudoers").grep(/#{owner}/).any?
      execute "Adding Sudo Capability ..." do
         user "root"
         command "echo '#{owner}  ALL=(ALL)       NOPASSWD:ALL' >> /etc/sudoers"
      end
   end
end
