#
# Cookbook Name:: orvsd-web
# Recipe:: static
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "nginx::default"

template "#{node['nginx']['dir']}/sites-available/media.orvsd.org.conf" do
  source "media.orvsd.org.conf.erb"
  owner "root"
  group "root"
  mode 00644
end

nginx_site "media.orvsd.org.conf" do
  :enable
end
