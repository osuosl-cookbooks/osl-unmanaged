#
# Cookbook Name:: racktables
# Recipe:: server
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "apache2::mod_php5"
if node['racktables']['ssl_enabled']
  include_recipe "apache2::mod_ssl"
end

%w{php php-mysql php-pdo php-gd php-snmp php-mbstring
   php-bcmath}.each do |pkg|
  package pkg do
    action :install
  end
end

web_app "racktables" do
  server_name "inventory2.osuosl.org"
  server_aliases ["inventory2"]
  docroot node['racktables']['dir']
  redirect_http node['racktables']['redirect_http']
  ssl_enabled node['racktables']['ssl_enabled']
  ssl_listen_ports node['racktables']['ssl_listen_ports']
end

directory node['racktables']['dir'] do
  owner node['apache']['user']
  group node['apache']['group']
  recursive true
  mode 0755
  action :create
end

directory "#{node['apache']['log_dir']}/racktables/" do
   mode 00755
end

