#
# Cookbook Name:: base
# Recipe:: users
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

if Chef::Config[:solo]
  include_recipe "user"
else 
  include_recipe "user::data_bag"
end
