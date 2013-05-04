#
# Cookbook Name:: orvsd-web
# Recipe:: static
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "orvsd-web::default"
include_recipe "nginx::default"

if node['orvsdweb']['static']['glusterpath']
  directory node['orvsdweb']['static']['glusterpath']
  mount node['orvsdweb']['static']['glusterpath'] do
    device node['orvsdweb']['static']['glustervol']
    fstype "glusterfs"
    options "defaults,_netdev"
    action [:mount, :enable]
  end
end

template "#{node['nginx']['dir']}/sites-available/#{node['orvsdweb']['static']['server_name']}.conf" do
  source "#{node['orvsdweb']['static']['server_name']}.conf.erb"
  owner "root"
  group "root"
  mode 00644
end

nginx_site "#{node['orvsdweb']['static']['server_name']}.conf" do
  :enable
end

node['nagios']['check_vhost']['server_name'] = node['orvsdweb']['static']['server_name']
