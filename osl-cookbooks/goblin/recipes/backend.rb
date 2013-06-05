#
# Cookbook Name:: goblin
# Recipe:: backend
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "postgresql::server"
include_recipe "rabbitmq"

# Allow PostgreSQL
simple_iptables_rule "postgres" do
  rule "--proto tcp --dport 5432"
  jump "ACCEPT"
end

# Allow RabbitMQ
simple_iptables_rule "rabbitmq" do
  rule "--proto tcp --dport 5672"
  jump "ACCEPT"
end

# Allow RabbitMQ admin
simple_iptables_rule "rabbitmqadmin" do
  rule "--proto tcp --dport 15672"
  jump "ACCEPT"
end

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

