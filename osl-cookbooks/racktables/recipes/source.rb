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
