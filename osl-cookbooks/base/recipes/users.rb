#
# Cookbook Name:: base
# Recipe:: users
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

#node.default['users'] = ['osl-root', 'osl-osuadmin']

include_recipe "user::data_bag"
