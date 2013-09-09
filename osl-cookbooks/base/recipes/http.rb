#
# Cookbook Name:: base
# Recipe:: http
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#
template "/etc/cron.daily/compress-http-logs" do
  source "compress-logs.erb"
  mode "755"
  owner "root"
  group "root"
end

package "pigz" do
    action :install
end
