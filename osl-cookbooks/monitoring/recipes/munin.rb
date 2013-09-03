#
# Cookbook Name:: monitoring
# Recipe:: munin
#
# Copyright 2013, OSU Open Source Lab

include_recipe "munin::server"

node.set['munin']['server_auth_method'] = htpasswd