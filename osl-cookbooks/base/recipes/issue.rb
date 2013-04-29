#
# Cookbook Name:: base
# Recipe:: issue
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "openssh"

# Manage /etc/issue login message
template "/etc/issue" do
  source "issue.erb"
  mode 0640
  owner "root"
  group "root"
end
