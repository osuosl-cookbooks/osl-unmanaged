#
# Cookbook Name:: goblin
# Recipe:: django
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "goblin::default"

web_app "goblin" do
  server_name node['hostname']
  template "apache.erb"
end
