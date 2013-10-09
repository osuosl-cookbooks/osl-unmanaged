#
# Cookbook Name:: racktables
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "racktables::#{node['racktables']['install_method']}"
include_recipe "racktables::server"

user 'racktables' do
  comment "racktables user"
  system true
  shell "/bin/false"
end
