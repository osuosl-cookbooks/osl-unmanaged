#
# Cookbook Name:: orvsd-web
# Recipe:: gluster
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "base::glusterfs"

if node['orvsdweb']['glusterpath']
  directory node['orvsdweb']['glusterpath']
  mount node['orvsdweb']['glusterpath'] do
    device volserver
    fstype "glusterfs"
    options "defaults,_netdev"
    action [:mount, :enable]
  end
end