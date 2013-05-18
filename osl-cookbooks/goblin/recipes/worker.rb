#
# Cookbook Name:: goblin
# Recipe:: worker
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "supervisor"
include_recipe "goblin"

supervisor_service "celery" do
  action [:enable,:start]
  autostart true
  user "nobody"
end