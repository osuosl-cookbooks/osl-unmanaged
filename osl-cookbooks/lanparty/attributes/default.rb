#
# Cookbook Name:: lanparty
# Attributes:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

default['lanparty']['game_user']  = 'osuadmin'
default['lanparty']['password']   = nil
default['lanparty']['game_group'] = node['lanparty']['game_user']
default['lanparty']['game_dir']   = '/opt'
