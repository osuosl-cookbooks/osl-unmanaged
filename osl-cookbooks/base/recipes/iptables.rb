#
# Cookbook Name:: base
# Recipe:: iptables
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Enable services on CentOS
case node["platform_family"]
when "rhel"
  service "iptables" do
    supports :status => true, :restart => true, :save => true
    action [:enable, :start]
  end
end
