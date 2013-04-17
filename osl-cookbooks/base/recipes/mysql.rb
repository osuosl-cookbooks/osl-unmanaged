#
# Cookbook Name:: base
# Recipe:: mysql
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Remove these packages if they exist
%w{mysql mysql-libs mysql55-libs}.each do |pkg|
  package pkg do
    action :remove
  end
end

template "/root/.my.cnf" do
  source "mysql/dot.my.cnf.erb"
  mode "600"
  owner "root"
  group "root"
end
