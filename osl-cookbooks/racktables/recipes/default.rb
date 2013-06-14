#
# Cookbook Name:: racktables
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"


app_name = 'racktables'
app_config = node[app_name]

src_filename = app_config['source']
src_filepath = "/tmp/Racktables.tar.gz"
tmp_path = "/tmp/RackTables-0.20.4"
extract_path = app_config['dir']

# Packages
%w{php php-mysql php-pdo php-gd php-snmp php-mbstring
   php-bcmath}.each do |pkg|
  package pkg do
    action :install
  end
end

# User
user app_name do
  comment "racktables user"
  system true
  shell "/bin/false"
end

# WWW Dir
directory extract_path do
  owner node['apache']['user']
  group node['apache']['group']
  recursive true
  mode 0644
  action :create
end

# vhost
web_app "racktables" do
  server_name "inventory2"
  server_aliases ["inventory2.osuosl.org"]
  docroot app_config['dir']
end


# wget & extract file
remote_file src_filepath do
  source src_filename
  checksum app_config['checksum']
  owner app_name
  group app_name
  action :create_if_missing
end

bash 'extract_module' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar xzf #{src_filepath}
    sudo cp -r #{tmp_path}/wwwroot #{extract_path}
    EOH
  #not_if { ::File.exists?(extract_path) }
end
