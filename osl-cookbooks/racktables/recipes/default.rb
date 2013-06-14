#
# Cookbook Name:: racktables
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#
include_attribute "racktables"

include_recipe "apache2"


app_name = 'racktables'
app_config = node[app_name]

src_filename = app_config['source']
src_filepath = "/tmp/racktables"
extract_path = app_config['dir']


directory extract_path do
  owner app_name
  group app_name
  mode 0644
  action :create
end

remote_file src_filename do
  source src_filepath
  checksum src_filepath
  owner app_name
  group app_name
  action :create_if_missing
end

#bash 'extract_module' do
#  cwd ::File.dirname(src_filepath)
#  code <<-EOH
#    mkdir -p #{extract_path}
#    tar xzf #{src_filename} -C #{extract_path}
#    mv #{extract_path}/*/* #{extract_path}/
#    EOH
#  not_if { ::File.exists?(extract_path) }
#end

%w{httpd php php-mysql php-pdo php-gd php-snmp php-mbstring
   php-bcmath}.each do |pkg|
  package pkg do
    action :install
  end
end
