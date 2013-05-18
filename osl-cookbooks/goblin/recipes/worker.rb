#
# Cookbook Name:: goblin
# Recipe:: worker
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "supervisor"

ruby supervisor_service "celery" do
  action :enable
  autostart true
  user "nobody"
end