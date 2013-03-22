#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

node['base']['packages'].each do |basepkg|
  package basepkg
end

chef_gem "chef-handler-mail", "~> 0.1.2"
