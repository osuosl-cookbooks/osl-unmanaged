#
# Cookbook Name:: base
# Recipe:: unmanaged
#
# Copyright 2013, OSU Open Source Lab
#

node.default['chef_client']['init_style'] = "none"
node.default['chef_client']['cron']['minute'] = "*/30"
node.default['chef_client']['cron']['hour'] = "*"
node.default['chef_client']['cron']['use_cron_d'] = "true"
node.default['chef_client']['cron']['log_file'] = "/var/log/chef/client.log"

include_recipe "base"
include_recipe "base::environment"
include_recipe "base::packages"
include_recipe "networking_basic"
include_recipe "chef-client::cron"
include_recipe "aliases"
include_recipe "openssh"
include_recipe "chef-client::delete_validation"
include_recipe "osl-munin::client"
