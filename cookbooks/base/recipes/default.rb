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
