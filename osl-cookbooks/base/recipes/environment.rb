#
# Cookbook Name:: base
# Recipe:: environment
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "rhel"
  template "/etc/environment" do
    source "environment.erb"
    mode 0644
    owner "root"
    group "root"
  end
end