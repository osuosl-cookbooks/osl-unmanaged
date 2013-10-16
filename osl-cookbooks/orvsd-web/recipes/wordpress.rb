#
# Cookbook Name:: orvsd-web
# Recipe:: wordpress
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "orvsd-web::default"

users = node['orvsdweb']['users']

user users do
    system true
    shell "/bin/false"
end


