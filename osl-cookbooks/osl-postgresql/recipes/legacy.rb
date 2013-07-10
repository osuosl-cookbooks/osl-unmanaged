#
# Cookbook Name:: osl-postgresql
# Recipe:: legacy
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

hba_data = [
  node.default['postgresql']['pg_hba'],
  {:type => 'host', :db => 'fsslgy_redmine', :user => 'fsslgy_redmine', :addr => '140.211.15.250/32', :method => 'md5'}
].flatten

node.set["postgresql"]["pg_hba"] = hba_data
