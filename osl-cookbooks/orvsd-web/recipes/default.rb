#
# Cookbook Name:: orvsd-web
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "base::glusterfs"
include_recipe "firewall::http"
include_recipe "monitoring::http"
