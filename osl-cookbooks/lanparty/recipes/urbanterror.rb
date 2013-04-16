#
# Cookbook Name:: lanparty
# Recipe:: urbanterror
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/#{node['lanparty']['urbanterror']['version']}" do
  source "#{node['lanparty']['urbanterror']['base_url']}/#{node['lanparty']['urbanterror']['version']}"
  action :create_if_missing
end

bash "unzip-urt42" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    unzip #{node['lanparty']['urbanterror']['version']}
    mv UrbanTerror42 "#{node['lanparty']['urbanterror']['full_game_dir']}"
  EOH
  creates "#{node['lanparty']['game_dir']}/#{node['lanparty']['urbanterror']['game_dir']}"
end

template "#{node['lanparty']['urbanterror']['full_game_dir']}/q3ut4/server.cfg" do
  source "urbanterror/server.cfg.erb"
  mode 00644
  owner node['lanparty']['game_user']
  group node['lanparty']['game_group']
end

template "#{node['lanparty']['urbanterror']['full_game_dir']}/q3ut4/mapcycle.txt" do
  source "urbanterror/mapcycle.txt.erb"
  mode 00644
  owner node['lanparty']['game_user']
  group node['lanparty']['game_group']
end

directory node['lanparty']['urbanterror']['full_game_dir'] do
  mode 00755
  owner node['lanparty']['game_user']
  group node['lanparty']['game_group']
  recursive true
end
