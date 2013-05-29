#
# Cookbook Name:: orvsd-web
# Recipe:: static
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "orvsd-web::default"
include_recipe "nginx::default"

case node['hostname']
when "static1"
  volserver = node['orvsdweb']['static']['glustervol'][0]
  backupvol = node['orvsdweb']['static']['glustervol'][1]
when "static2"
  volserver = node['orvsdweb']['static']['glustervol'][1]
  backupvol = node['orvsdweb']['static']['glustervol'][0]
end

if node['orvsdweb']['static']['glusterpath']
  directory node['orvsdweb']['static']['glusterpath']
  mount node['orvsdweb']['static']['glusterpath'] do
    device volserver
    fstype "glusterfs"
    options "defaults,_netdev"
    action [:mount, :enable]
  end
end

server_name = node['orvsdweb']['static']['server_name']
template "#{node['nginx']['dir']}/sites-available/#{server_name}.conf" do
  source "#{server_name}.conf.erb"
  owner "root"
  group "root"
  mode 00644
end

nginx_site "#{server_name}.conf" do
  :enable
end
