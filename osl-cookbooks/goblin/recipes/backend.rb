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
include_recipe "goblin"