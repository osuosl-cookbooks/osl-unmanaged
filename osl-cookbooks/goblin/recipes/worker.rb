#
# Cookbook Name:: goblin
# Recipe:: worker
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "supervisor"
include_recipe "goblin::default"
include_recipe "goblin::django"

supervisor_service "celery" do
  action [:enable,:start]
  autostart true
  autorestart true
  user "nobody"
  startsecs 10
  stopwaitsecs 600
  command "/var/www/goblin/shared/env/bin/celeryd -l info"
  directory "/var/www/goblin/current"
end
