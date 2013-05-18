#
# Cookbook Name:: base
# Recipe:: packages
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "rhel"
  include_recipe 'yum::yum'
  include_recipe 'yum::epel'
  include_recipe 'base::oslrepo'
end

# Install the base packages
node['base']['packages'].each do |basepkg|
  package basepkg
end
