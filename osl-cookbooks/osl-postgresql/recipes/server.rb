#
# Cookbook Name:: osl-postgresql
# Recipe:: server
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Include OSL defaults
include_recipe 'osl-postgresql::default'

# Include the server bits
include_recipe 'postgresql::server'
include_recipe 'postgresql::config_pgtune'
include_recipe 'postgresql::contrib'
include_recipe 'firewall::postgres'
