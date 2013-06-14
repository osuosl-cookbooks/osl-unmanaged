#
# Cookbook Name:: orvsd-web
# Recipe:: memcache
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

package "php53u-pecl-memcache"

service "memcached" do
  action [:start,:enable]
end

template "/etc/php.d/memcache.ini" do
  source "memcache.ini.erb"
  mode 00644
end
