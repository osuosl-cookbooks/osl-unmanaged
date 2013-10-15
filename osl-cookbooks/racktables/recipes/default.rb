#
# Cookbook Name:: racktables
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "racktables::server"
include_recipe "racktables::#{node['racktables']['install_method']}"

user 'racktables' do
  comment "racktables user"
  system true
  shell "/bin/false"
end

template "secret.php" do
    path "#{node['racktables']['source']['install_dir']}/wwwroot/inc/secret.php"
    source 'secret.php.erb'
    mode "0666"
    action :create
end
