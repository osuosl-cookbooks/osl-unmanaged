#
# Cookbook Name:: monitoring
# Recipe:: mysql
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Add defaults file for mysql nagios checks
template "#{node['nagios']['nrpe']['conf_dir']}/mysql.cnf" do
  source "mysql.cnf.erb"
  mode "600"
  owner "#{node['nagios']['user']}"
  group "#{node['nagios']['group']}"
end

# Check mysql processlist 
nagios_nrpecheck "pmp-check-mysql-processlist" do
  command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-processlist"
  action :add
end

# Check mysql problems inside innodb 
nagios_nrpecheck "pmp-check-mysql-innodb" do
  command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-innodb"
  action :add
end

# Check for mysql pidfile
nagios_nrpecheck "pmp-check-mysql-pidfile" do
  command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-pidfile"
  action :add
end

# Check replication
nagios_nrpecheck "pmp-check-mysql-replication-delay" do
  command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-replication-delay"
  action :add
end

