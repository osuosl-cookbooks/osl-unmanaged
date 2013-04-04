#
# Cookbook Name:: base
# Recipe:: packages
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Install the base packages
node['base']['packages'].each do |basepkg|
  package basepkg
end
