#
# Cookbook Name:: monitoring
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Check for high load.  This check defines warning levels and attributes
nagios_nrpecheck "check_load" do
  command "#{node['nagios']['plugin_dir']}/check_load"
  warning_condition "6"
  critical_condition "10"
  action :add
end

# Check all non-NFS/tmp-fs disks.
nagios_nrpecheck "check_all_disks" do
  command "#{node['nagios']['plugin_dir']}/check_disk"
  warning_condition "8%"
  critical_condition "5%"
  parameters "-A -x /dev/shm -X nfs -X fuse.glusterfs -i /boot"
  action :add
end

# Check for excessive users.  This command relies on the service definition to
# define what the warning/critical levels and attributes are
nagios_nrpecheck "check_users" do
  command "#{node['nagios']['plugin_dir']}/check_users"
  action :remove
end
