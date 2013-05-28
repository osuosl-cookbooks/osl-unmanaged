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

rabbitmq_vhost "/optin" do
  action :add
end

rabbitmq_user "optin" do
  vhost "/optin"
  password "CbXVtHJHFmwgE"
  action [:add]
end
rabbitmq_user "optin" do
  permissions ".* .* .*"
  action [:set_permissions]
end
rabbitmq_user "optin" do
  tag "goblin"
  action [:set_tags]
end
