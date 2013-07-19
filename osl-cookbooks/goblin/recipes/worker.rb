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


%w{/var/www/goblin/current/conversion_email_in_progress /var/www/goblin/current/conversion_email_google /var/www/goblin/current/conversion_email_psu}.each do |conv|
  file conv do
    mode 0755
    action :touch
  end
end

supervisor_service "celery" do
  action [:enable,:start]
  autostart true
  autorestart true
  user "optin"
  process_name "%(program_name)s"
  numprocs 1
  startsecs 10
  stopwaitsecs 600
  command "/bin/bash /var/www/goblin/current/bin/wrapper.sh"
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

simple_iptables_rule "munin" do
  rule "--proto tcp --dport 4949"
  jump "ACCEPT"
end

directory "/var/log/imapsync" do
  owner "root"
  group "www-data"
  mode 0770
end
