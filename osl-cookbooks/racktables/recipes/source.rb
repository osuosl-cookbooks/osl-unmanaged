#
# Cookbook Name:: racktables
# Recipe:: source
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

version = node['racktables']['source']['version']
install_dir = node['racktables']['source']['install_dir']

directory node['racktables']['source']['install_dir'] do
  owner node['apache']['user']
  group node['apache']['group']
  mode 0755
  action :create
end

remote_file "#{Chef::Config['file_cache_path']}/Racktables-#{version}.tar.gz" do
  source node['racktables']['source']['url']
  checksum node['racktables']['source']['checksum']
  backup false
  action :create
end

bash 'extract_module' do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
    tar xzvf Racktables-#{version}.tar.gz
    (cp -r RackTables-#{version}/* #{install_dir})
    (chown -R #{node['apache']['user']}:#{node['apache']['group']} #{install_dir})
  EOH
end
