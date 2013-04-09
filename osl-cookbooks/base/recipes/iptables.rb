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
    service_name 'iptables'
    supports :status => true, :restart => true, :save => true
    action :start
    action :enable
  end
end
