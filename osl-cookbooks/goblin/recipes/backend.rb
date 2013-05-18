#
# Cookbook Name:: goblin
# Recipe:: backend
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "postgresql"
include_recipe "rabbitmq"

# Configure postgres for webapp
node['postgresql']['config_pgtune']['db_type'] = "web"