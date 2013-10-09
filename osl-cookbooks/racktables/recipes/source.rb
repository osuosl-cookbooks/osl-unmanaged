#
# Cookbook Name:: racktables
# Recipe:: source
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

src_filepath = "/tmp/Racktables.tar.gz"
tmp_path = "/tmp/RackTables-0.20.4"

# Packages
%w{php php-mysql php-pdo php-gd php-snmp php-mbstring
   php-bcmath}.each do |pkg|
  package pkg do
    action :install
  end
end

# User
user 'racktables' do
  comment "racktables user"
  system true
  shell "/bin/false"
end

# WWW Dir
directory node['racktables']['dir'] do
  owner node['apache']['user']
  group node['apache']['group']
  recursive true
  mode 0755
  action :create
end

# vhost
web_app "racktables" do
  server_name "inventory2.osuosl.org"
  server_aliases ["inventory2"]
  docroot node['racktables']['dir']
  redirect_http node['racktables']['redirect_http']
  ssl_enabled node['racktables']['ssl_enabled']
  ssl_listen_ports node['racktables']['ssl_listen_ports']
end


# wget & extract file
remote_file src_filepath do
  source node['racktables']['source']
  checksum node['racktables']['checksum']
  owner 'racktables'
  group 'racktables'
  action :create_if_missing
end

bash 'extract_module' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar xzf #{src_filepath}
    sudo cp -r #{tmp_path}/wwwroot/* #{node['racktables']['dir']}
    EOH
  #not_if { ::File.exists?(node['racktables']['dir']) }
end
