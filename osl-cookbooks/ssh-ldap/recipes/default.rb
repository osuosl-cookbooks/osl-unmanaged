#
# Cookbook Name:: ssh-ldap
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#
include_recipe "openssh"

# Manage ssh ldap configuration
template "/etc/ssh/ldap.conf" do
  source "ldap.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

package "openssh-ldap" do
  action :install
end
