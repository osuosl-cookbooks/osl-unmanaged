#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Configure the OSL yum repository
yum_repository "osl" do
  repo_name "osl"
  description "OSL repo $releasever - $basearch"
  url "http://packages.osuosl.org/repositories/centos-$releasever/osl/$basearch"
  key "RPM-GPG-KEY-zenoss"
  action :add
end

# Install and require the mail handler gem
chef_gem "chef-handler-mail" do
  action :install
end
gem 'chef-handler-mail'

# Send email to root
chef_handler "MailHandler" do
  source 'chef/handler/mail'
  arguments :to_address => "root"
  action :nothing
end.run_action(:enable)

# Install the base packages
node['base']['packages'].each do |basepkg|
  package basepkg
end

# Enable services
service "iptables" do
  service_name 'iptables'
  supports :status => true, :restart => true, :save => true
  action :enable
end

# Set up interfaces if they are defined in the data bag
begin
  net_dbag = data_bag_item('networking', @node[:hostname])
rescue
  net_dbag = nil
end

if net_dbag
  net_dbag['interfaces'].each_value do |ifcfg|
    ifconfig ifcfg['inet_addr'] do
      ignore_failure true
      device ifcfg['device']
      bootproto ifcfg['bootproto']
      mask ifcfg['mask']
      bcast ifcfg['bcast']
      onboot ifcfg['onboot'] if ifcfg['onboot']
      mtu ifcfg['mtu'] if ifcfg['mtu']
    end
  end
  net_dbag['routes'].each_value do |r|
    route r['network'] do
      ignore_failure true
      gateway r['gateway']
      netmask r['netmask'] if r['netmask']
      device r['device'] if r['device']
    end
  end
end

