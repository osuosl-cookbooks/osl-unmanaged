#
# Cookbook Name:: orvsd-web
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "yum::epel"
include_recipe "base::glusterfs"
include_recipe "firewall::http"
unless Chef::Config[:solo]
  include_recipe "monitoring::http"
end
