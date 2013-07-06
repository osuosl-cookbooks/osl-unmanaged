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
  user "optin"
  process_name "%(program_name)-%(process_num)s"
  numprocs 20
  startsecs 10
  stopwaitsecs 600
  command "/bin/bash /var/www/goblin/shared/env/bin/activate && /var/www/goblin/current/bin/celeryd start"
  directory "/var/www/goblin/current"
end

template "/opt/google-imap/cyrus.pf" do
  source "cyrus.pf.erb"
  mode 00644
  owner "root"
  group "www-data"
end

template "/opt/google-imap/google-prod.pf" do
  source "google-prod.pf.erb"
  mode 00644
  owner "root"
  group "www-data"
end
