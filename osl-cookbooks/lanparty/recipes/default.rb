#
# Cookbook Name:: lanparty
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

user_account node['lanparty']['game_user'] do
  password node['lanparty']['password']
  ssh_keys node['lanparty']['game_user_keys']
end
